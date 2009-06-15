Return-Path: <linux-kernel-owner+w=401wt.eu-S1760170AbZFOJJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbZFOJJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZFOJJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:09:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52387 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751165AbZFOJJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:09:20 -0400
Date: Mon, 15 Jun 2009 10:09:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] WARN(): add a \n to the message printk
Message-ID: <20090615100951.1571bf03@lxorguk.ukuu.org.uk>
In-Reply-To: <20090615000822.6e6bf282@infradead.org>
References: <20090615000822.6e6bf282@infradead.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (args) {
>  		vprintk(args->fmt, args->args);
> +		printk("\n");

What stops another printk occuring between those two ?

Alan
