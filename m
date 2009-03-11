Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbZCKCVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbZCKCVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 22:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZCKCVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 22:21:11 -0400
Received: from mx1.suse.de ([195.135.220.2]:38568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbZCKCVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 22:21:10 -0400
Date: Wed, 11 Mar 2009 03:21:07 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, mpm@selenic.com,
       linux-mm@kvack.org
Subject: Re: PROBLEM: kernel BUG at mm/slab.c:3002!
Message-ID: <20090311022107.GB16561@wotan.suse.de>
References: <49B68450.9000505@hp.com> <alpine.DEB.1.10.0903101339210.9350@qirst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903101339210.9350@qirst.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 01:40:02PM -0400, Christoph Lameter wrote:
> Oh nice memory corruption. May have something to do with the vmap work by
> Nick.

Hmm, it might but I can't really tell. It happens in the vmap code
when kmallocing something, but it isn't obviously causing it AFAIKS.

Could you print out the values of the fields involved in the BUG()?
That might give some clues...
