Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbZAFNAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbZAFNAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 08:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbZAFNAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 08:00:08 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:52488 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbZAFNAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 08:00:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=MFEGaA7LPpOknYOiPW8FouTU5VbHR97L3Fzp+Fv5k5ZXAMwY2S1Kt/4OPaqNYcHG3n
         S/08c8je1xNk3Pq/EETwYNlG1zmYAxlpogCHuA8mwzslCVURH3i/84cBZhBLv2J2153u
         Q/ocwuRGXyVpnyY7aBYTKRyinOBEdZYIi930k=
Message-ID: <c4e36d110901060500w289708d5ne252ace7a2fd9944@mail.gmail.com>
Date: Tue, 6 Jan 2009 14:00:03 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: MCE error log
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've noticed mcelog with weird content:

MCE 0
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 1 BANK 128 TSC 57976afd
STATUS 88380100 MCGSTATUS 0
MCE 0
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 1 BANK 128 TSC 53e61034
STATUS 88370100 MCGSTATUS 0

I'm running T61 - 2GB - in this directory
/sys/devices/system/machinecheck/machinecheck1
I could only see  bank0ctl ... bank5ctl - so where is bank 128 ?
(as there are no time stamps, I could hardly guess how often this happens)

Is it kernel bug or chipset bug ?
Should I start to worry about the stability of my machine ?

Zdenek
