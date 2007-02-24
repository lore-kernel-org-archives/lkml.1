Return-Path: <linux-kernel-owner+w=401wt.eu-S932566AbXBXNI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbXBXNI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 08:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932569AbXBXNI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 08:08:58 -0500
Received: from web52912.mail.yahoo.com ([206.190.49.22]:30231 "HELO
	web52912.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932566AbXBXNI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 08:08:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=6ebaJi2EJFb9OXyzHqWECVatArs4Wmx3ce7ouuamqhwdBaSH6FLAfnz1a+2glYTq+rAzYMqtVLcVHcQSYCX0Vt0Eh21NTfT3OxjeqwtnRUwN6dNBYjE/fsE6qZoMEai1KIj2+VZF3LV0l0yJGCxbBNnP/S6vdEWLu/+ZgJ6Cf7A=;
X-YMail-OSG: sTp6Lo0VM1ncZK59H4c3ijLfUMnqOh4_rsEOfoJY00CwJgebsEfIyxKt8gQSa7ZOTChewMNWDcAeHSWjV8KFXVcE8qy64M56z4AqkuxPj7JgG3nggLUsL2nuiu8drL6BjVFBVDHUsZIFuy4-
Date: Sat, 24 Feb 2007 13:08:56 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Kernel warning from Matrox Framebuffer in 2.6.20.1
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <306590.53720.qm@web52912.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have just booted 2.6.20.1 on my Pentium 3 machine, which has a G400 MAX graphics card. This
machine uses the Matrox framebuffer and TV-OUT modules, and I have found these warnings in the
kernel log:

**WARNING** I2C adapter driver [DDC:fb0 #0] forgot to specify physical device; fix it!
**WARNING** I2C adapter driver [DDC:fb0 #1] forgot to specify physical device; fix it!
**WARNING** I2C adapter driver [MAVEN:fb0] forgot to specify physical device; fix it!

The relevant kernel modules seem to be:

matroxfb_maven         13228  0
i2c_matroxfb            4064  0
i2c_algo_bit            6312  1 i2c_matroxfb

Cheers,
Chris



		
___________________________________________________________ 
All New Yahoo! Mail – Tired of unwanted email come-ons? Let our SpamGuard protect you. http://uk.docs.yahoo.com/nowyoucan.html
