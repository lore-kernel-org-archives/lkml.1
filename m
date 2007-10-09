Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbXJISub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbXJISub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbXJISuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:50:22 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34774 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753047AbXJISuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:50:20 -0400
Date: Tue, 9 Oct 2007 11:50:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] slub: fix cpu hotplug offline/online path
In-Reply-To: <84144f020710091148s6267a69aud18348af77f941b0@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710091149221.32730@schroedinger.engr.sgi.com>
References: <20071009161328.GA6470@APFDCB5C> 
 <Pine.LNX.4.64.0710091144020.32162@schroedinger.engr.sgi.com>
 <84144f020710091148s6267a69aud18348af77f941b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007, Pekka Enberg wrote:

> Hi Christoph,
> 
> On 10/9/07, Christoph Lameter <clameter@sgi.com> wrote:
> > Could you check if a per cpu structure has already been allocated and then
> > simply skip the call to init? Otherwise we end up with lots of per cpu
> > structures for cpus that will never show up.
> 
> Does it matter? How?

Our system come by default with the possibility of 1k cpus. However, a 
small system may only have 8 cpus.
