Return-Path: <linux-kernel-owner+w=401wt.eu-S1765612AbYAaVN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765612AbYAaVN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 16:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbYAaVNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 16:13:20 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:36855 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbYAaVNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 16:13:20 -0500
Date: Thu, 31 Jan 2008 13:30:52 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86_64: make bootmap_start page align v6
In-reply-to: <20080131210553.GA15221@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-id: <200801311330.53587.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801291113.35974.yinghai.lu@sun.com>
 <200801311244.11206.yinghai.lu@sun.com> <20080131210553.GA15221@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 January 2008 01:05:53 pm Ingo Molnar wrote:
> 
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
> > [PATCH] x86_64: make bootmap_start page align v6
> > 
> > need to apply after x86_64: add debug name for early_res
> > 
> > boot oops when system get 64g or 128 installed
> 
> thanks - this v6 approach looks a _lot_ saner because it solves the core 
> problem: the fragility of the early allocator code. They are also 
> cleanups, besides being fixes. Applied.
> 
> does this solve all the boot problems you were seeing with 64 or 128 GB 
> of RAM?


yes. 

YH
