Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbXJ3JBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbXJ3JBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbXJ3JA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:00:57 -0400
Received: from www.tglx.de ([62.245.132.106]:52385 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbXJ3JA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:00:56 -0400
Date: Tue, 30 Oct 2007 10:00:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Jimenez <pj@place.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH] KJ: Make i8259_64 more _32-like
In-Reply-To: <20071030064050.C401D8B2B@place.org>
Message-ID: <alpine.LFD.0.9999.0710300959100.3186@localhost.localdomain>
References: <20071030064050.C401D8B2B@place.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007, Paul Jimenez wrote:

> 
> Howdy! Here's a simple janitorish patch for you:
> 
> This patch mainly hinges around two includes and their ramifications:
> 
> #include <i8259.h>	which provides cached_{slave,master}_mask
> #include <io_ports.h>	which provides PIC_{MASTER,SLAVE}_{IMR,CMD} 
> 
> Adding these two includes and using those half dozen or so definitions
> removed 140+ lines of diffs between i8259_32.c and i8259_64.c, thus
> making it easier for the real substantitive differences between them to
> show up, and hopefully therefore making it easier to eventually merge
> the two.

Looks good. Can you please resend with a proper Signed-off-by ?

Run your patch through scripts/checkpatch.pl before sending it out :)

    tglx
