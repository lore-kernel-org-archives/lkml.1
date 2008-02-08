Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbYBHXnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbYBHXnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYBHXnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:43:06 -0500
Received: from relay2.sgi.com ([192.48.171.30]:55110 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752862AbYBHXnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:43:03 -0500
Date: Fri, 8 Feb 2008 17:43:02 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       andrea@qumranet.com, avi@qumranet.com, izike@qumranet.com,
       kvm-devel@lists.sourceforge.net, a.p.zijlstra@chello.nl,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, general@lists.openfabrics.org
Subject: Re: [patch 0/6] MMU Notifiers V6
Message-ID: <20080208234302.GH26564@sgi.com>
References: <20080208220616.089936205@sgi.com> <20080208142315.7fe4b95e.akpm@linux-foundation.org> <Pine.LNX.4.64.0802081528070.4036@schroedinger.engr.sgi.com> <20080208233636.GG26564@sgi.com> <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 03:41:24PM -0800, Christoph Lameter wrote:
> On Fri, 8 Feb 2008, Robin Holt wrote:
> 
> > > > What about ib_umem_get()?
> 
> Correct.
> 
> You missed the turn of the conversation to how ib_umem_get() works. 
> Currently it seems to pin the same way that the SLES10 XPmem works.

Ah.  I took Andrew's question as more of a probe about whether we had
worked with the IB folks to ensure this fits the ib_umem_get needs
as well.

Thanks,
Robin
