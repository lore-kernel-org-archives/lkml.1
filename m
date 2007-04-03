Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbXDCXzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbXDCXzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbXDCXzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:55:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35279 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753250AbXDCXzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:55:17 -0400
Date: Tue, 3 Apr 2007 16:55:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm4
In-Reply-To: <1175644314.6185.18.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0704031653060.12109@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> 
 <1175637332.6185.4.camel@dyn9047017100.beaverton.ibm.com> 
 <1175642398.6185.9.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031626020.12109@schroedinger.engr.sgi.com> 
 <1175643507.6185.12.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031638570.12109@schroedinger.engr.sgi.com>
 <1175644314.6185.18.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Badari Pulavarty wrote:

> Hmm. booted fine with slub_debug :(

Try to selectively disable debug options... if you got the 
time...

F.e. Try with sanity checks only

slub_debug=F

then with redzoning

slub_debug=FZ

and do one with poisoning

slub_debug=FP

Maybe slub_debug avoided a race condition.


