Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbZAFOsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbZAFOsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 09:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZAFOsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 09:48:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbZAFOsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 09:48:45 -0500
Date: Tue, 6 Jan 2009 15:48:43 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Cliff Wickman <cpw@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [patch] x86: make UV support optional
Message-ID: <20090106144843.GH16738@wotan.suse.de>
References: <20090106060348.GA16738@wotan.suse.de> <20090106143330.GB18913@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106143330.GB18913@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 08:33:30AM -0600, Jack Steiner wrote:
> On Tue, Jan 06, 2009 at 07:03:48AM +0100, Nick Piggin wrote:
> > UV is fairly rare.... and much of the support is already there to cope with
> > 32-bit builds. So this makes sense I think.
> >
> 
> 
> Looks ok to me. One suggestion though. There is a MAXSMP config
> option. I would suggest enabling UV if MAXSMP is enabled. This
> will help ensure that UV is tested more frequently & may minimize
> regressions.

Yeah.... I don't know. OTOH it would be more logical to enable
MAXSMP iff UV is enabled (or change the MAXSMP limits for when
UV is enabled). Or you could select Intel CPUs if UV is enabled,
or disable GRU if UV is not set etc etc.

I didn't want to get too fancy with config options because arbitrary
linkages seem to just cause headaches. I figure if someone wants
to enable it, they can do so.

