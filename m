Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbXD1RLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbXD1RLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756467AbXD1RLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:11:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460AbXD1RLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:11:18 -0400
Date: Sat, 28 Apr 2007 13:11:01 -0400
From: Dave Jones <davej@redhat.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-ID: <20070428171101.GC20646@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org
References: <20070423141123.GA21174@skybase> <20070423104534.51bac974.akpm@linux-foundation.org> <20070425112133.4ae86399.randy.dunlap@oracle.com> <20070425143011.57247c1d.akpm@linux-foundation.org> <20070425172447.1576c399.akpm@linux-foundation.org> <20070426003911.GA19383@redhat.com> <4630109F.6090002@oracle.com> <20070425200207.77a2721a.akpm@linux-foundation.org> <20070428030805.GA13331@redhat.com> <20070428161136.GL11166@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070428161136.GL11166@waste.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 11:11:36AM -0500, Matt Mackall wrote:
 > > I'm all ears for additional regexps, bug reports or other suggestions.
 > 
 > Neat.
 > 
 > Does it check for:
 > 
 > functions marked extern?
 > pulling in external functions or variables without a header file?
 > return used as a function, eg return(foo);?

These sound a little more tricky than just dumb regexps.
I don't want to expand this to a fullblown C parser (given
that we have sparse which can do a better job), but I don't
object to adding some extra code to give the searches more
context.

	Dave

-- 
http://www.codemonkey.org.uk
