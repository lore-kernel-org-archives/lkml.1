Return-Path: <linux-kernel-owner+w=401wt.eu-S1761195AbZD1NJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761195AbZD1NJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbZD1NJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:09:47 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:44658 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbZD1NJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:09:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=T305c6rljGRf+gXNJwzgd81qTIKPD36NTo3sfSssPc00MpN8P+DXd3mcr+Mvf6TJdB
         VrAJzZckaR+6poUDHXmwG+kMTEAUfuWXD6UGZYBzkWH+czqQN8vqYZcBYjaaVwRD3qha
         Mm+9v5OipWBoui5FtSBcDFtTbeTx28yEUYyOM=
MIME-Version: 1.0
Date: Tue, 28 Apr 2009 15:09:46 +0200
Message-ID: <b637ec0b0904280609h2583e72ds38867bdf7867a0a2@mail.gmail.com>
Subject: OT - Regression: Cisco VPN module hangs 2.6.30-rcX
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.
Please forgive me if this question is considered offtopic on this
list. I'm not sure where to post it.

Anyway, I have a regression between 2.6.30-rcX and every other version
I tried with regards to Cisco proprietary cisco_ipsec.ko module.

The module compiles cleanly, loads and the VPN connection is created.
So far so good. The problem is that as soon as I send packets on the
tunnel (TCP - UDP doesn't matter, even a nslookup quesry i enough),
the system hangs without messages on console / logs. Powercycle is
needed.

Tested with 2.6.30-rc1 and 2.6.30-rc3 with same results. Last good
version is 2.6.29.2 . Arch is x86 without SMP.

The client version is the latest available to my knowledge,
vpnclient-linux-x86_64-4.8.02.0030-k9.tar.gz .

I don't know how to debug this, maybe some people from Cisco on this
list can help.

Thanks and regards,
Fabio
