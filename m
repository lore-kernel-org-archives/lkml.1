Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbXJBPpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbXJBPpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbXJBPpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:45:21 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41389 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbXJBPpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:45:20 -0400
Date: Tue, 2 Oct 2007 17:45:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Joe Perches <joe@perches.com>
cc: Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] printk: add KERN_CONT annotation
In-Reply-To: <1191339692.13170.18.camel@localhost>
Message-ID: <Pine.LNX.4.64.0710021744060.7130@fbirervta.pbzchgretzou.qr>
References: <20070928105345.GC18163@shadowen.org>  <20071001064448.GA4239@elte.hu>
  <20071001003007.4e90143b.akpm@linux-foundation.org>  <20071002043408.GM10199@1wt.eu>
  <20071002051852.GC28345@elte.hu> <1191339692.13170.18.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 2 2007 08:41, Joe Perches wrote:
>On Tue, 2007-10-02 at 07:18 +0200, Ingo Molnar wrote:
>> +#define	KERN_CONT	""
>
>This doesn't work with printk(char** array[index]) continuations
>or with strings with embedded KERN_ prefixes.

Huh?
...Ah. Yeah, pasting a string literal with a variable won't work.
But then again, you should not use printk(var) directly, but always
use printk("%s", var)
