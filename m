Return-Path: <linux-kernel-owner+w=401wt.eu-S936112AbXEUT5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936112AbXEUT5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934381AbXEUTeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:34:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45949 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933805AbXEUTeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:34:04 -0400
Date: Mon, 21 May 2007 12:34:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <Pine.LNX.4.64.0705212026080.5442@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0705211231250.27209@schroedinger.engr.sgi.com>
References: <20070520133505.46147.qmail@web52609.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0705210917280.25871@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705211835140.26666@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705211121570.26794@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705211930370.31659@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705211147100.26970@schroedinger.engr.sgi.com>
 <20070521190043.GA4705@kernel.dk> <Pine.LNX.4.64.0705211208270.27129@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705212026080.5442@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Hugh Dickins wrote:

> > the problem. And the earlier case that you reported was a version of SLUB 
> > that did not have the capability to switch off SLUB_DEBUG.
> 
> Are you sure?  If CONFIG_EMBEDDED=y then -rc1 and -rc2 give you the
> choice to turn it off.

Right. That went in indeed shortly before the rc1 release.

So if both had disabled SLUB_DEBUG then this could be the reason for the 
failure. However, CONFIG_SLUB_DEBUG was set in the .config that was 
included when this bug was reported. So I think we still have not found 
the real problem yet.

