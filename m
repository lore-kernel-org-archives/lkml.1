Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbXJWTt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbXJWTt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 15:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbXJWTtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 15:49:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41582 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbXJWTtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 15:49:21 -0400
Message-ID: <471E5021.8090300@cs.helsinki.fi>
Date: Tue, 23 Oct 2007 22:48:49 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: SLUB 0:1 SLAB (OOM during massive parallel kernel builds)
References: <20071023181615.GA10377@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0710231227590.19626@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710231227590.19626@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 23 Oct 2007, Alexey Dobriyan wrote:
> > cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0

Christoph Lameter wrote:
> Regular Order 0 alloc .... but why is there no memory available , 
> reclaimed?

I am too wondering where all that memory is going. Logging /proc/meminfo 
and slabinfo -S (see Documentation/vm/slabinfo.c) every few minutes or 
so probably might help answering that question.

				Pekka

