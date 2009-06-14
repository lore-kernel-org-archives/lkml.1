Return-Path: <linux-kernel-owner+w=401wt.eu-S1762370AbZFNQ0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762370AbZFNQ0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 12:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbZFNQ0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 12:26:11 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:21093 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbZFNQ0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 12:26:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gnilm/KzAswo7n04/KxBR889n1VpK2SUKFlKEQvks1hBDZjNbbEnTWzhqUy2I5Kruv
         gQcqNxovMZILZ0zGKZEVZbWVKhSw8trdUk4R8VV7PrTpMSsPsdQvvLGUR7hykGcb9Of/
         iVLbKF6wZgqNbv1YEcqPEoefho5NGrvF86XtA=
MIME-Version: 1.0
In-Reply-To: <19209.93239.qm@web31703.mail.mud.yahoo.com>
References: <233030.36441.qm@web31706.mail.mud.yahoo.com>
	 <4A333E0D.8050306@gmail.com>
	 <19209.93239.qm@web31703.mail.mud.yahoo.com>
Date: Sun, 14 Jun 2009 10:26:12 -0600
Message-ID: <51f3faa70906140926p2e34cb47j1ad8e9332c893c0d@mail.gmail.com>
Subject: Re: PCIe interface memory memory mapping issue
From: Robert Hancock <hancockrwd@gmail.com>
To: Sanka Piyaratna <cesanka@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 6:43 AM, Sanka Piyaratna<cesanka@yahoo.com> wrote:
>
> Hi Robert
>
>
> Thanks for your reply.
>
>>> I have developed a PCI express interface using Xilinx ML555 hardware module. I have implemented Linux kernel >>mode device drivers and everything works correctly as long as I am using the device within a computer with dual >>channel DDR arrangement. However, as soon as I pug this device into a core i7 or an older single channel DDR >>machine, the interface memory mapping does not work any more. As if the register map with in the device does no >>longer exsists. However, "lspci" utility provides correct information. I am not sure if this has anything to do with the >>number of DDR memory channels the motherboard has or why that would be a problem for PCI express device. >>However, this seem to be the common link between the machines that demonstrate this issue.
>
>>You'll have to give more details on what you mean by "the interface memory mapping does not work any more. As if >the register map with in the device does no longer exsists".
>
> What I mean by this is that, when load the driver, the memory mapping of the hardware memory onto the computer memory does not work. I have a setup where I have all the control registers in BAR5 (512 byte) and I also have 64kB chuck of the FPGA memory mapped using BAR0. I am not able to see the register space when the BAR5 area in the computer memory map. However, I am able to write something to BAR0 memory map and read it back.

How are you getting the register space into the memory map.. ioremap() ?
