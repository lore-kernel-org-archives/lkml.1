Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbXK0SPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbXK0SPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 13:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbXK0SPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 13:15:30 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44856 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757636AbXK0SP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 13:15:29 -0500
Date: Tue, 27 Nov 2007 10:15:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Mosberger-Tang <dmosberger@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, tony.luck@intel.com
Subject: Re: [patch 04/14] ia64: Remove the __SMALL_ADDR_AREA attribute for
 per cpu access
In-Reply-To: <ed5aea430711262120p45bb5b2t1b16872e74547369@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711271014550.2310@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com>  <20071127001430.083503280@sgi.com>
 <ed5aea430711262120p45bb5b2t1b16872e74547369@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, David Mosberger-Tang wrote:

> On 11/26/07, Christoph Lameter <clameter@sgi.com> wrote:
> > The model(small) attribute is not supported by gcc 4.X. The tests
> > will always be negative today.
> 
> What was the rationale for removing this attribute?

The code is then similar across all architectures and can be moved into 
generic code.

