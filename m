Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbYJaXgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbYJaXgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 19:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbYJaXgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 19:36:23 -0400
Received: from lazybastard.de ([212.112.238.170]:36689 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYJaXgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 19:36:23 -0400
Date: Sat, 1 Nov 2008 00:36:15 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Sean Young <sean@mess.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library
Message-ID: <20081031233614.GA24960@logfs.org>
References: <20081026124643.GA1328@logfs.org> <20081031201745.GA93714@atlantis.8hz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081031201745.GA93714@atlantis.8hz.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 October 2008 20:17:45 +0000, Sean Young wrote:
> On Sun, Oct 26, 2008 at 01:46:44PM +0100, Joern Engel wrote:
> > General advantages of btrees are memory density and efficient use of
> > cachelines.  Hashtables are either too small and degrade into linked
> > list performance, or they are too large and waste memory.  With changing
> > workloads, both may be true on the same system.  Rbtrees have a bad
> > fanout of less than 2 (they are not actually balanced binary trees),
> > hence reading a fairly large number of cachelines to each lookup.
> 
> Which reminds me:
> 
> find_vma() uses rbtrees. Now I assume find_vma() is called far more than
> mmap() and friends. Since avltree are balanced (unlike rbtrees) lookups
> will be faster at the expense of extra rotations during updates.

Maybe I should have been clearer.  Rbtrees _are_ balanced trees.  They
are not balanced _binary_ trees, but balanced 234-trees in a binary
representation.

> Would patches for avltrees be accepted?

The question is whether they are an improvement.  As always.

Jörn

-- 
Das Aufregende am Schreiben ist es, eine Ordnung zu schaffen, wo
vorher keine existiert hat.
-- Doris Lessing
