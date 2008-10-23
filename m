Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYJWQOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYJWQOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYJWQOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:14:34 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:43842 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbYJWQOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:14:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=a9TUld3wlpdMAVrceKx3FoGrjLVH5AFbUSaTBMaOZAzvUcGQR52T/1oVXmxwiJgrsc
         AjVRZ9SUv/211SHgbtV6PAuB1f5AJy+SfKBCcPAB0JwEqzJ0GKd8cFvj8XM6ImBk/y5x
         UJMGvjGWt6E8nJZKLjPjKqfdbXRb9FrOvebaw=
Message-ID: <376ea3380810230914m32080a97t34a8b66e4e4039db@mail.gmail.com>
Date: Thu, 23 Oct 2008 09:14:32 -0700
From: "Jon Dufresne" <jon.dufresne@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: RTL8111/8168B multicast bug
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Are there any known bugs regarding using the "Realtek Semiconductor
Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller" to
receive multicast packets?

I am developing a piece of software to receive a multicast signal as
produced by the mp4live program in the mpeg4ip project. The software
has worked on a wide variety of hardware until I got to this one
machine with the above realtek chip.  I noticed it was unable to
connect to the stream. I was never able to get it to properly receive
the signal until I put in a new NIC, a "3Com Corporation
3c905C-TX/TX-M" and now the program is once again receiving multicast
packets.

So I believe the realtek driver is possibly not doing something correctly.

Are there any known issues with my hardware? Is there anything I could
do from a kernel space or user space level that would further help
diagnose the problem?

My OS is an up to date Fedora with all fedora packages except the
piece of software I am developing.

Thanks,
Jon
