Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbYAUCe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbYAUCe7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 21:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbYAUCet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 21:34:49 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:46360 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbYAUCet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 21:34:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gw8vjyRZ5SGpcrD7aBA/9b4FTB1jOpa/+Co0NHhioqNqIgGZzhCLx8qVCa0RmbAg3yOGkaxGMfo2W46I2vPfvmUcXiBHovsuOyXkXGwMaQ+rQfZANeXVV9bn8bxmgm+EL3YR2PReeofHquUwL8PT9fGZ9/RqWFmdbxwjiGzn3Vo=
Message-ID: <3b7d7830801201834o3f03380eu5c9d82912acd0e3c@mail.gmail.com>
Date: Mon, 21 Jan 2008 10:34:45 +0800
From: "Lost Garden" <yuanzhiqiang13@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PCI Interrupt Problems Since Kernel-2.6.19
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    I'm writing a driver for DVB-C PCI receiving cards these days and
I found a tricky problem of interrupts. Since kernel-2.6.19 the
interrupt handlers get rid of "struct pt_regs*" argument  and I think
it will be easy for me to modify the driver to fit for the recent
kernel.
   I simply delete the "struct pt_regs *" argument of my interrupt
handler and compile the driver again. But then I met a rather tricky
problem. I cann't get the PCI intterrupt now! I found that the chip on
the card actually had generate an interrupt and it should not be the
hardware problem.
  I'm get seriously confused. My driver works well under kernel-2.6.18
but not generates a single interrupt signal when works above
kernel-2.6.19.
 Does anybody meet similar problems?
 Sincerely
 Yours, Lost Graden.
1,21. 2008
