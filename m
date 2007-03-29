Return-Path: <linux-kernel-owner+w=401wt.eu-S1422654AbXC2WAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422654AbXC2WAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422653AbXC2WAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:00:31 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:60550 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422654AbXC2WAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=tpN4PTowG+CYKIiCaGx+TzjNq66mpofg2ze4ptMsxbaJlKeh2wnmECADvueKs6AyEX9FEUcf0cXAW4q2cb5TNH+TkO7KDt0iuNnnBZzSs4O2RjiVvgm7Sq+9tKDBnjQsMbdSmYEkPDkp3hUIGrHFwPrcN3E9P+C3+Kf05vslbNw=
Message-ID: <e8f45b9e0703291500y3b495fa4o9320fe1bf726189b@mail.gmail.com>
Date: Fri, 30 Mar 2007 00:00:29 +0200
From: "Gerard Braad Jr." <me@gbraad.nl>
To: linux-kernel@vger.kernel.org
Subject: P5B-VM, problems with Memory remap and Linux (wont address more than 2.8Gb)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: b7232a158b8075ec
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

sorry for the scarce technical information in this email. this is
mostly due to it being mentioned before. I experience problems with
the P5B-VM mainboard when using it with 4gb and Linux. When the Memory
remap is activated, the internal network card is unusable (disabled).
The system turns to be almost unusably slow... And in normal use, only
2.8gb is available... Is there a solution around this? I use BIOS 0613
and Fedora Core 6 (kernel 2.6.19-1... x86_64).

Also the IDE bus experiences problems... it seems when there is a lot
of traffic on the Realtek, the PATA channel keeps sending reset
signals. The drive i use is a: ASUS DRW-1612BL. It is also described
in the following mailinglists.

   http://lkml.org/lkml/2007/3/12/398
   http://lists.centos.org/pipermail/centos/2007-January/074575.html
   http://lists.netfilter.org/pipermail/netfilter/2006-November/067431.html

With some of these people I had contact... trying to resolve the
problem, but until now we are unable to do so.

Setup of at least 2 identical machines:
   ASUS P5B-VM
   4 DIMM's (Kingston KVR667D2N5K2/2G; DDR2 PC5300 1GB 667)
   Intel Core 2 Duo E6600 (not overclocked, 2.4 Ghz)
   1 Seagate 320Gb harddisk (sata)
   1 ASUS DVD Burner (pata)

These systems are used as headless VMware servers. This situation I
experience on all systems based on this mainboard. Not sure if this
also occurs on the P5B mainboard... :-S

Is there a solution available to make these systems work with 4Gb,
full speed, a working R8169 (8111B) and no errors on IDE? If you need
any debug information, please tell me what I need to do...

yours sincerely,


Gerard
