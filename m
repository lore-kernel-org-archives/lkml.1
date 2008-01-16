Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYAPWa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYAPWa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbYAPWUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:20:53 -0500
Received: from relay1.sgi.com ([192.48.171.29]:48924 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755594AbYAPWUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:20:52 -0500
Date: Wed, 16 Jan 2008 14:20:50 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Johannes Weiner <hannes@saeurebad.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
In-Reply-To: <87odblct19.fsf@saeurebad.de>
Message-ID: <Pine.LNX.4.64.0801161419290.11922@schroedinger.engr.sgi.com>
References: <87lk6pvii0.fsf@saeurebad.de> <alpine.LFD.1.00.0801161026550.2806@woody.linux-foundation.org>
 <87odblct19.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008, Johannes Weiner wrote:

> So if I got it right and you actually modify the memory you only got a
> const pointer to, you reach a level where you _have to_ break this
> policy and cast to a non-const pointer, as it is currently done in
> kfree().  No?

Correct and we have gcc 4.2 currently spitting out warnings because of 
casting to non const. Any idea how to convince gcc that this is okay?
 
