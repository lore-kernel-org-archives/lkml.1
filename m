Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbXLTTq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbXLTTq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 14:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbXLTTqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 14:46:47 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:34745 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbXLTTqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 14:46:46 -0500
Date: Thu, 20 Dec 2007 13:41:01 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [RFC] [PATCH 1/3] Merge mkimage tool for building uImages
Message-ID: <20071220134101.679d90cd@zod.rchland.ibm.com>
In-Reply-To: <476AB640.4040005@zytor.com>
References: <20071220101643.48b427ef@zod.rchland.ibm.com>
	<20071220101739.45b28d26@zod.rchland.ibm.com>
	<476AB640.4040005@zytor.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 10:36:48 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Josh Boyer wrote:
> > Several platforms require the mkimage tool to generate a uImage file
> > that is used with U-Boot.  This brings the mkimage tool in-kernel to
> > enable building those platforms without having mkimage internally
> > provided.
> > 
> > This is currently based off of the version found in U-Boot 1.3.1.
> > 
> 
> Can we rename it either "ubootimage" or "mkuboot" or something else that 
> tells the user what kind of image it is?  (It is, in particular, not 
> bzImage, which is probably the first thing that someone who sees "image" 
> in a arch-generic part of the Linux kernel tree will think.)

We can, yes.  I have no particular objection to that and I've often
found mkimage to be too generic of a name myself.  For the initial
round of patches, I just wanted to keep things as similar to what is
in U-Boot as possible.

josh
