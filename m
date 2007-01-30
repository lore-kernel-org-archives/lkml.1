Return-Path: <linux-kernel-owner+w=401wt.eu-S965490AbXA3J5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965490AbXA3J5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 04:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965485AbXA3J5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 04:57:19 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53252 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965490AbXA3J5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 04:57:18 -0500
Date: Tue, 30 Jan 2007 12:53:16 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Samuel Thibault <samuel.thibault@labri.fr>, linux-kernel@vger.kernel.org,
       libc-hacker@sources.redhat.com, libc-alpha@sources.redhat.com
Subject: Re: [ANN] Userspace M-on-N threading model implementation. Alpha release.
Message-ID: <20070130095316.GD2455@2ka.mipt.ru>
References: <20070129145227.GA10524@2ka.mipt.ru> <40f323d00701290747y68c8e27ege824694bfa378f58@mail.gmail.com> <20070130011817.GI3541@interface.residence.ens-lyon.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070130011817.GI3541@interface.residence.ens-lyon.fr>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Tue, 30 Jan 2007 12:53:25 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 02:18:17AM +0100, Samuel Thibault (samuel.thibault@labri.fr) wrote:
> Hi,
> 
> Evgenity, le Mon 29 Jan 2007 16:47:36 +0100, a écrit :
> > Userspace M-on-N threading model is based on the idea, that when signal
> > is delivered, kernel saves all information related to previous context
> > in stack, so it is possible to find it and replace.
> 
> You may want to have a look at some existing implementations:

I saw most of them.
As far as I recall, only PTL (is not shown here) has preemptible
scheduler. NTL has it too, but is based on different approach.

> - Good old `FSU Pthreads' http://moss.csc.ncsu.edu/~mueller/pthreads/
> - fully POSIX-compliant `GnuPth' http://www.gnu.org/software/pth/
> - server-targetted `Capriccio'
> www.cs.berkeley.edu/~jcondit/capriccio-sosp-2003.pdf
> - efficient `ELiTE/Erlangen'
> http://www4.informatik.uni-erlangen.de/Projects/FORTWIHR/ELiTE/
> - and our portable, flexible, efficient `Marcel'
> http://runtime.futurs.inria.fr/marcel/
> 
> Samuel

-- 
	Evgeniy Polyakov
