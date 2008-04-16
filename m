Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbYDPTS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbYDPTS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYDPTSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:18:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33789 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750822AbYDPTSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:18:49 -0400
Date: Wed, 16 Apr 2008 12:18:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: mm/page_alloc.c: remove hand-coded get_order()
In-Reply-To: <87ej97tna8.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0804161218230.14718@schroedinger.engr.sgi.com>
References: <20080415092317.GA1529@elf.ucw.cz> <87ej97tna8.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008, Andi Kleen wrote:

> Pavel Machek <pavel@ucw.cz> writes:
> >
> > What about creating void *get_free_pages(flags, order) version, then
> > slowly converting users to it?
> 
> Then we would also need a free_pages() that takes void *, but unfortunately
> free_pages() already has other semantics.

But it would be more consistent.

