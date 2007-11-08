Return-Path: <linux-kernel-owner+w=401wt.eu-S1762736AbXKHUYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762736AbXKHUYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 15:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757013AbXKHUYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 15:24:24 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49176 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754177AbXKHUYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 15:24:24 -0500
Date: Thu, 8 Nov 2007 12:24:22 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <1194553148.20832.10.camel@lappy>
Message-ID: <Pine.LNX.4.64.0711081222340.10228@schroedinger.engr.sgi.com>
References: <20071106195144.983665861@sgi.com>  <20071106195157.878563669@sgi.com>
 <1194522615.6289.136.camel@twins>  <Pine.LNX.4.64.0711081030380.7871@schroedinger.engr.sgi.com>
 <1194553148.20832.10.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007, Peter Zijlstra wrote:

> > The convention for macros is to use upper case.
> 
> We have plent macros that look like regular functions. And as a primary
> interface to this functionality these shouting things look really out of
> place.

One point of the patchset is to clean up the messy handling of the 
allocpercpu interface which uses lower case for macros. It is a bit 
confusing that a function like alloc_percpu() can take a type argument. 
I think this needs to be uppercase for clarity.


