Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbXEYWgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbXEYWgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 18:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbXEYWgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 18:36:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:47881 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbXEYWgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 18:36:08 -0400
Subject: Re: [patch 1/7] ps3: Preallocate bootmem memory for the PS3 FLASH
	ROM storage driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert.Uytterhoeven@sonycom.com
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070525083632.177254000@sonycom.com>
References: <20070525083607.784351000@sonycom.com>
	 <20070525083632.177254000@sonycom.com>
Content-Type: text/plain
Date: Sat, 26 May 2007 08:35:39 +1000
Message-Id: <1180132539.19517.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-25 at 10:36 +0200, Geert.Uytterhoeven@sonycom.com wrote:
> -#if defined(CONFIG_FB_PS3) || defined(CONFIG_FB_PS3_MODULE)
> +#if defined(CONFIG_FB_PS3) || defined(CONFIG_FB_PS3_MODULE) || \
> +    defined(CONFIG_PS3_FLASH_MODULE) ||
> defined(CONFIG_PS3_FLASH_MODULE)

As I said multiple times, imho, #ifdef CONFIG_xxx_MODULE in the kernel
is always a bug.

You should always be able to build the module out of tree afteward and
use it on a kernel that didn't have the CONFIG_xxx_MODULE set imho.

Ben.


