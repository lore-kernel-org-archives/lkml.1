Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502Ab0ATMMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0ATMMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 07:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682Ab0ATMMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 07:12:34 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:48458 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab0ATMMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 07:12:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U2OJnvpULlKcsj2cBfGgs8STtWUHxQG8WtewI69jaE142tcLYZlUWkIEe1fZGYbZVJ
         Jz/DWYw9JgrEI5jy/p2xb44Ciz7ukIoCFn6OCaxvWqfiZ5wKvVL/BWalXHR6JG60zUdf
         KaBYChu8b8EnHWrN//vxl0/jmZrkRTf4/hKvE=
MIME-Version: 1.0
In-Reply-To: <1259146071-2372-1-git-send-email-amit.kucheria@verdurent.com>
References: <1259146071-2372-1-git-send-email-amit.kucheria@verdurent.com>
Date: Wed, 20 Jan 2010 15:12:29 +0300
Message-ID: <48239d391001200412i7736354dg4e07076a63d7b966@mail.gmail.com>
Subject: Re: [PATCH] mfd: twl4030: Driver for twl4030 madc module
From: Sergey Lapin <slapinid@gmail.com>
To: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: sameo@linux.intel.com, List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-omap@vger.kernel.org, Mikko Ylinen <mikko.k.ylinen@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all!

On Wed, Nov 25, 2009 at 1:47 PM, Amit Kucheria
<amit.kucheria@verdurent.com> wrote:
> From: Mikko Ylinen <mikko.k.ylinen@nokia.com>
>
> This ADC allows monitoring of analog signals such as battery levels,
> temperatures, etc.
>
> Several people have contributed to this driver on the linux-omap list.
>
> Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
> ---
>  drivers/mfd/Kconfig              |   21 ++
>  drivers/mfd/Makefile             |    3 +-
>  drivers/mfd/twl4030-madc.c       |  548 ++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/twl4030-madc.h |  126 +++++++++
>  4 files changed, 697 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/mfd/twl4030-madc.c
>  create mode 100644 include/linux/i2c/twl4030-madc.h
>

We have just tried to adopt this driver to our custom OMAP3 board, but
were unable to get any interrupts.
Any ideas on what is missing? We've checked whole TRM and found
nothing wrong yet :(

Thanks a lot.
S.
