Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbXLSUrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbXLSUrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 15:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbXLSUrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 15:47:10 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:53222 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbXLSUrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 15:47:09 -0500
Date: Wed, 19 Dec 2007 21:47:08 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Trying to convert old modules to newer kernels
In-Reply-To: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com>
Message-ID: <Pine.LNX.4.64.0712192142060.5524@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 19 2007 15:10, linux-os (Dick Johnson) wrote:


>I got rid of __init and anything else that I thought could cause the fault,

I anticipate the day removing __init causes a breakage, heh.
I mean, if all in-tree modules and LDD3 use it, it can't be wrong, can it?

>plus got rid of all the code!
>static int32_t startup()

I noticed that. Where's your "void" gone? :-)
And usually, the init routine returns int, not int32_t,
even if it's the same in current development models.
(I don't think you run an ILP64-compiled kernel.)

#include <linux/autoconf.h> is also not advised.
