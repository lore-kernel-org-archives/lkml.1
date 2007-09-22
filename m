Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbXIVXyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbXIVXyO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 19:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbXIVXyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 19:54:00 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:29975 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbXIVXx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 19:53:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:organization:user-agent:x-accept-language:mime-version:to:subject:content-type:content-transfer-encoding;
        b=HuSfh1YNIgwQXurR/40N8IAbBtYK+SIKRnK568FpVvvCE6Egx9DXALJqTihCVsJOKR7VJC6A6HFnJakyCssJP+UhB4la4HbaunWbwrPklcJlZxCBYw49wSwH6VdDwvpeb0E4uE9s4m57ykB88nWKwkSASr7YBv+AycX+0Req8bw=
Message-ID: <46F5AB46.3030202@gmail.com>
Date: Sat, 22 Sep 2007 20:54:46 -0300
From: Hernan G Solari <hgsolari@gmail.com>
Reply-To: hgsolari@gmail.com
Organization: Universidad de Buenos Aires
User-Agent: Debian Thunderbird 1.0.2 (X11/20060927)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Serial ATA does not find partitions (Hitachi HD, new? ATI controller)
 where old SATA works
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello
    I am disturbing you with this problem because I think there is
something to be learnt, I have
no urgency or further-problem with my work-around.

Description: trying to boot with kernel 2.6.22  the booting process
stops not finding
the root partition, in the previous line it gives an EMPTY list of
available partitions.
Disabling completely the (Serial) ATA driver and enabling the old SATA
driver is my work-around (a regresion).
Installing linux with debian 4.0 is possible (kernel 2.6.18.4-amd64),
but ubuntu crashes
silently after loading kernel and initrd.image (I guess it is the same
problem).

Description of the machine, dmesg output with kernel 2.6.22, lspci,
modules, cpu, iomem, ioports, acpi-table as well as instalation story at
http://www.df.uba.ar/~solari/acer.html

Hitachi 120Gb drive
scsi 0:0:0:0: Direct-Access ATA Hitachi HTS54161 SBDO PQ: 0 ANSI: 5

ATI controller
00:12.0 IDE interface: ATI Technologies Inc 4379 Serial ATA Controller
(rev 80)
 (prog-if 8f [Master SecP SecO PriP PriO])
Subsystem: Acer Incorporated [ALI] Unknown device 010f
(pci.ids are up-to-day)

The acpi system does not work either, but I have reported the problem to
a more specific list.

I can test patches in case you want.

                               thanks for your attention
                                                                        
      Hernan


-- 
Hernán Gustavo Solari, solari@df.uba.ar, http://www.df.uba.ar/~solari

