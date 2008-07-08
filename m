Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbYGHWI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbYGHWI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 18:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755726AbYGHWIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 18:08:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676AbYGHWIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 18:08:46 -0400
Date: Tue, 8 Jul 2008 18:08:33 -0400
From: Rik van Riel <riel@redhat.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, kyle@mcmartin.ca,
       kmcmartin@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padlock: don't whinge when loaded on a non-VIA cpu
Message-ID: <20080708180833.61d24b60@bree.surriel.com>
In-Reply-To: <20080708193741.GB28899@phobos.i.cabal.ca>
References: <20080708190427.GA28899@phobos.i.cabal.ca>
	<20080708195211.1565f3d1@the-village.bc.nu>
	<20080708193741.GB28899@phobos.i.cabal.ca>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008 15:37:41 -0400
Kyle McMartin <kyle@mcmartin.ca> wrote:

> +	if (!((boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR) &&
> +	     (boot_cpu_data.x86 >= 6)))	/* only on VIA C3 and above */
> +		return -ENODEV;

Why add this?

>  	if (!cpu_has_xcrypt) {
>  		printk(KERN_ERR PFX "VIA PadLock not detected.\n");
>  		return -ENODEV;

When you could simply delete the printk lines?

-- 
All rights reversed.
