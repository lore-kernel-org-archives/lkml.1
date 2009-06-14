Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbZFNMn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbZFNMn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbZFNMnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:43:21 -0400
Received: from web31703.mail.mud.yahoo.com ([68.142.201.183]:32522 "HELO
	web31703.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755004AbZFNMnU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:43:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=WPHFringvG6nyDdXIdwEzoWKpAu0cS52qvFHQvtEYRXIqVgOeczjZeQa+y+YoKacElrcVF4W4JFDsdx2zfwAElFJJRXdYDO4CO/Xcs0SUWQSFpfth9WtR8h8tL//rM1ybpczH4fxv+JZMWEAevYfU1zi+t1dUMk00qHp6qtKgPI=;
Message-ID: <19209.93239.qm@web31703.mail.mud.yahoo.com>
X-YMail-OSG: pQqFNnwVM1khM9Ux.TultlOk3wlj2RCdPE1V4rksgtCijuBPQgsvFafgCkHYRZWxEMU_oY5ohRwBGKOJ3zRRyZIf2f7xNA782jAGTLvMug3N.Ml.4HpJuGMTQyo8tnUacHTPBKk2WKG5LQfvc86b5oqhS1Ml.tDLPHBmHDJiP.DMxZ1npECzKV34OxfMMU0BmVGvoo2X0L7I8EDEFZpI1XdOvlUzvOc08I89x10rTa6t6g.AUWQyTkXkpLvW_Q3gW.fxEj7jM0UeQ6bVvFBncAIOhOqFaxgwPeuEfjxUG2bZVmKbijmPqD7xtEoTfr6rcHkJh1ejN.YLIxmW5kJFl74rX99H9rA3tccAFLEEK3eakCxEl.I4Lg_dUeuczrye
X-Mailer: YahooMailRC/1357.18 YahooMailWebService/0.7.289.15
References: <233030.36441.qm@web31706.mail.mud.yahoo.com> <4A333E0D.8050306@gmail.com>
Date: Sun, 14 Jun 2009 05:43:22 -0700 (PDT)
From: Sanka Piyaratna <cesanka@yahoo.com>
Subject: Re: PCIe interface memory memory mapping issue
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4A333E0D.8050306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Robert


Thanks for your reply.

>> I have developed a PCI express interface using Xilinx ML555 hardware module. I have implemented Linux kernel >>mode device drivers and everything works correctly as long as I am using the device within a computer with dual >>channel DDR arrangement. However, as soon as I pug this device into a core i7 or an older single channel DDR >>machine, the interface memory mapping does not work any more. As if the register map with in the device does no >>longer exsists. However, "lspci" utility provides correct information. I am not sure if this has anything to do with the >>number of DDR memory channels the motherboard has or why that would be a problem for PCI express device. >>However, this seem to be the common link between the machines that demonstrate this issue.

>You'll have to give more details on what you mean by "the interface memory mapping does not work any more. As if >the register map with in the device does no longer exsists".

What I mean by this is that, when load the driver, the memory mapping of the hardware memory onto the computer memory does not work. I have a setup where I have all the control registers in BAR5 (512 byte) and I also have 64kB chuck of the FPGA memory mapped using BAR0. I am not able to see the register space when the BAR5 area in the computer memory map. However, I am able to write something to BAR0 memory map and read it back.

Thanks and regards,

Sanka



      Need a Holiday? Win a $10,000 Holiday of your choice. Enter now.http://us.lrd.yahoo.com/_ylc=X3oDMTJxN2x2ZmNpBF9zAzIwMjM2MTY2MTMEdG1fZG1lY2gDVGV4dCBMaW5rBHRtX2xuawNVMTEwMzk3NwR0bV9uZXQDWWFob28hBHRtX3BvcwN0YWdsaW5lBHRtX3BwdHkDYXVueg--/SIG=14600t3ni/**http%3A//au.rd.yahoo.com/mail/tagline/creativeholidays/*http%3A//au.docs.yahoo.com/homepageset/%3Fp1=other%26p2=au%26p3=mailtagline
