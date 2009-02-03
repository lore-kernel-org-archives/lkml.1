Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbZBCLvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbZBCLvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbZBCLvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:51:23 -0500
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:43117 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752156AbZBCLvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:51:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=k3MDWxDjfAJB3Qm1ufCEei1A2DLa5xwIOr1f4tmP5LyCZpCPAsabN0qrIrSrSjFHrjy3UUzIm9Rxlu2ZTbyAVQBDobG2E7nV5gGpOfBLPUYzzeuwsB2jWxQ45usBqIKt8fgPXlI4I8Odh3g4BFJ1Kwy+yHMlgkEQt8H9Ly4OzfI=  ;
X-YMail-OSG: 8hoZVhAVM1kdSUbBxmCpe2Zo9ZM8SfO70GheRT1zgt7FouCinAqaBwsjcb_75GxyJ9yKI6mfszak4mi1jSztpK7xBMprH1w4oE5rDZScfkM9qixknS70GuU5qU7NPgfQR4p0QbZDguX9QouA6DhONMdcAm8BfM9qQQtUhbaS_U20ipVD0g5PYbsstPbrvw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [patch] SLQB slab allocator (try 2)
Date: Tue, 3 Feb 2009 22:50:54 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
References: <20090123154653.GA14517@wotan.suse.de> <200902032136.26022.nickpiggin@yahoo.com.au> <20090203112852.GJ9840@csn.ul.ie>
In-Reply-To: <20090203112852.GJ9840@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902032250.55968.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009 22:28:52 Mel Gorman wrote:
> On Tue, Feb 03, 2009 at 09:36:24PM +1100, Nick Piggin wrote:

> > I'd be interested to see how slub performs if booted with
> > slub_min_objects=1 (which should give similar order pages to SLAB and
> > SLQB).
>
> Just to clarify on this last point, do you mean slub_max_order=0 to
> force order-0 allocations in SLUB?

Hmm... I think slub_min_objects=1 should also do basically the same.
Actually slub_min_object=1 and slub_max_order=1 should get closest I
think.

