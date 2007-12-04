Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbXLDMAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbXLDMAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbXLDMAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:00:44 -0500
Received: from web26905.mail.ukl.yahoo.com ([217.146.176.94]:30288 "HELO
	web26905.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752739AbXLDMAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:00:43 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Dec 2007 07:00:42 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=d0Ff+foI+6glgxCMix5qSKIpjogEWpp+zNqhXyMP3Y+w31zu9wCIipRjQR2LSy/pHAh9fIwIzzfXtv6HoZrqURoyR1yLTvZhKEP3cHhXiT4wh2KZELoGt7bkGdm7PD46uFmjVf711tyEVJtaVlfd1pD+d9IkJkv+/c6BZcX4OPA=;
X-YMail-OSG: 5dsqtr0VM1k3D7BGTsyRossZAI_JOWEbNUTDgPbAbt1N_ChwRLuMKz.4bdxvV7l_f16GIGLEEpdJuh8ytphWZLNCFau3ttwQgTrvB5.UxkeVPWCB
Date: Tue, 4 Dec 2007 12:54:01 +0100 (CET)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re: PROBLEM: loadlin incompatible with 2.6.23 kernels
To: linux-kernel@vger.kernel.org
Cc: kmh@nerdshack.com, davidsen@tmr.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <462551.26009.qm@web26905.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kenneth Howlett wrote:
> The loadlin boot loader fails to boot 2.6.23 kernels.

 Maybe not a solution with loadlin, but is it working with the "tiny.exe" version
of Gujin?
 Download:
http://www.mirrorservice.org/sites/download.sourceforge.net/pub/sourceforge/g/gu/gujin/install-2.3.tar.gz/install/tiny.exe?extract=true
 and execute under DOS:
tiny c:\vmlinuz c:\initrd.img root=/dev/hda4 ro
 or maybe (to use an alternate way to collect BIOS data and the 32 bits entry point):
tiny /p c:\vmlinuz c:\initrd.img root=/dev/hda4 ro

 To have debug data on a DOS file named "DBG" you may download:
http://www.mirrorservice.org/sites/download.sourceforge.net/pub/sourceforge/g/gu/gujin/standard-2.3.tar.gz/lotiny.exe?extract=true
 and execute (with or without /p):
lotiny c:\vmlinuz c:\initrd.img root=/dev/hda4 ro
 If you want that debug on screen (screen will be messy, but the last few lines may
tell you the problem, and that is the only solution if the DBG file is not properly
closed by DOS), download:
http://www.mirrorservice.org/sites/download.sourceforge.net/pub/sourceforge/g/gu/gujin/standard-2.3.tar.gz/lodtiny.exe?extract=true
 and execute (with or without /p):
lodtiny c:\vmlinuz c:\initrd.img root=/dev/hda4 ro

 It may not help if you are stuck with loadlin, but may tell if it is a kernel problem
or a loadlin problem.
 More info for Gujin at http://gujin.org - current version v2.3

 Etienne.


      _____________________________________________________________________________ 
Ne gardez plus qu'une seule adresse mail ! Copiez vos mails vers Yahoo! Mail 
