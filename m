Return-Path: <linux-kernel-owner+w=401wt.eu-S1752329AbYJ0Emd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbYJ0Emd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 00:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbYJ0EmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 00:42:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:58900 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbYJ0EmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 00:42:25 -0400
Date: Mon, 27 Oct 2008 13:42:07 +0900
To: jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mingo@elte.hu,
       jens.axboe@oracle.com
Subject: Re: [PATCH] x86: remove dead BIO_VMERGE_BOUNDARY definition
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49023712.4030201@goop.org>
References: <20081024143836K.fujita.tomonori@lab.ntt.co.jp>
	<49023712.4030201@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081027134137D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008 13:58:58 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> FUJITA Tomonori wrote:
> > The block layer dropped the virtual merge feature
> > (b8b3e16cfe6435d961f6aaebcfd52a1ff2a988c5). BIO_VMERGE_BOUNDARY
> > definition is meaningless now.
> >   
> 
> Hm, I think we still need something here, no?

I don't think so.


> I have a couple of patches to make x86 use BIOVEC_PHYS_MERGEABLE 
> instead, which would probably apply to other arches.

As I wrote, the patch doesn't look correct (I think that the first
patch is fine if some arch want to use __BIOVEC_PHYS_MERGEABLE but no
one in mainline overrides BIOVEC_PHYS_MERGEABLE):

http://lkml.org/lkml/2008/10/27/1
