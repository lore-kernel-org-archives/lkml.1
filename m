Return-Path: <linux-kernel-owner+w=401wt.eu-S932107AbXKHXus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbXKHXus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 18:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762060AbXKHXue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 18:50:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43962
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760274AbXKHXud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 18:50:33 -0500
Date: Thu, 08 Nov 2007 15:26:55 -0800 (PST)
Message-Id: <20071108.152655.205050648.davem@davemloft.net>
To: clameter@sgi.com
Cc: peterz@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711081222340.10228@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711081030380.7871@schroedinger.engr.sgi.com>
	<1194553148.20832.10.camel@lappy>
	<Pine.LNX.4.64.0711081222340.10228@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Thu, 8 Nov 2007 12:24:22 -0800 (PST)

> On Thu, 8 Nov 2007, Peter Zijlstra wrote:
> 
> > > The convention for macros is to use upper case.
> > 
> > We have plent macros that look like regular functions. And as a primary
> > interface to this functionality these shouting things look really out of
> > place.
> 
> One point of the patchset is to clean up the messy handling of the 
> allocpercpu interface which uses lower case for macros. It is a bit 
> confusing that a function like alloc_percpu() can take a type argument. 
> I think this needs to be uppercase for clarity.

Without a doubt.
