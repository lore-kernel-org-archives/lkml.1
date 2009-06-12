Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbZFLXZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbZFLXZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 19:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZFLXZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 19:25:19 -0400
Received: from mail-qy0-f177.google.com ([209.85.221.177]:55566 "EHLO
	mail-qy0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZFLXZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 19:25:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=sJ0A9AfkPbCMWAl99jIhltDs48HvYF1cK8BT8V8YD8Gq0yozxzvRRlYXbomK6ROfmP
         1EFd7ENV3GH8jB+Zk79ygb7PuHEICUepwZCxy42V/wgjMRghhW3drmlaFRqnPZVMH5YO
         BARKifAWZtsBLeEBxKMOa08uF2uqiHWjbiFq4=
MIME-Version: 1.0
Date: Fri, 12 Jun 2009 19:25:20 -0400
Message-ID: <9e4733910906121625p68d1fbcdyd12b110248a3ac9d@mail.gmail.com>
Subject: build failure in PPC mpc5200_psc_ac97
From: Jon Smirl <jonsmirl@gmail.com>
To: linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new driver for AC97 on the mpc5200 has landed in front of Timur's
patch implementing spin_event_timeout().  Timur's patch is in
powerpc-next which hasn't been merged yet. mpc5200_psc_ac97 will build
ok after this merge happens.

-- 
Jon Smirl
jonsmirl@gmail.com
