Return-Path: <linux-kernel-owner+w=401wt.eu-S933131AbXCVPW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbXCVPW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933185AbXCVPW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:22:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58753 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933131AbXCVPWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:22:55 -0400
Subject: Re: max_loop limit
From: Arjan van de Ven <arjan@infradead.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070322141146.GN2986@holomorphy.com>
References: <460236CE.1030303@slax.org>
	 <20070322110058.GB23664@tatooine.rebelbase.local>
	 <46026A92.4020106@slax.org> <20070322144210.73dfaf83.dada1@cosmosbay.com>
	 <20070322134230.GP19922@kernel.dk>
	 <20070322145245.a49fefeb.dada1@cosmosbay.com>
	 <20070322135456.GS19922@kernel.dk>  <20070322141146.GN2986@holomorphy.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 22 Mar 2007 16:22:40 +0100
Message-Id: <1174576960.1158.178.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 07:11 -0700, William Lee Irwin III wrote:
> On Thu, Mar 22 2007, Eric Dumazet wrote:
> >> Sure, but it's the first Tomas patch :)
> 
> On Thu, Mar 22, 2007 at 02:54:57PM +0100, Jens Axboe wrote:
> > The more the reason to guide him in the direction of a right solution,
> > instead of extending the current bad one!
> 
> On Thu, Mar 22 2007, Eric Dumazet wrote:
> >> Apparently the 'current crap' didnt caugth someone else attention.
> 
> On Thu, Mar 22, 2007 at 02:54:57PM +0100, Jens Axboe wrote:
> > I guess most people don't care, 8 is enough for them and the wasted
> > memory isn't too much to care about - 8 devices and only one used, is
> > wasting at least ~14kb on my machine here.
> 
> Any chance we can get some kind of devices set up for partitions of
> loop devices if we're going to redo loopdev setup? That's been a thorn
> in my side for some time.

you can already do that with devmapper and partx combo...


