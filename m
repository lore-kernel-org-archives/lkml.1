Return-Path: <linux-kernel-owner+w=401wt.eu-S1762113AbXK2B1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762113AbXK2B1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760933AbXK2B1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:27:38 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45559 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754604AbXK2B1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:27:38 -0500
Date: Wed, 28 Nov 2007 17:27:37 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
In-Reply-To: <20071129011802.GK24223@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0711281727180.19859@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com> <200711281236.02014.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0711281050470.11968@schroedinger.engr.sgi.com>
 <200711291017.52727.rusty@rustcorp.com.au> <474DFD7E.907@goop.org>
 <Pine.LNX.4.64.0711281604560.17738@schroedinger.engr.sgi.com>
 <20071129011802.GK24223@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Andi Kleen wrote:

> On Wed, Nov 28, 2007 at 04:11:37PM -0800, Christoph Lameter wrote:
> > 1. The stack canary
> 
> You would need to change gcc with a new option and only allow the stack
> checking when the compiler supports the new option. However the problem
> is still how to get a reasonable fixed offset. Or perhaps just change
> gcc to use a linker symbol relative to %gs that could be set to anything?

I still think we should leave the canary as is.
