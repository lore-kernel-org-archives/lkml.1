Return-Path: <linux-kernel-owner+w=401wt.eu-S932506AbYJKR5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbYJKR5M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 13:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932415AbYJKR4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 13:56:53 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:43215 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402AbYJKR4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 13:56:52 -0400
Date: Sat, 11 Oct 2008 19:56:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: petkovbb@gmail.com
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Robert Hancock <hancockr@shaw.ca>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] ide: locking improvements
Message-ID: <20081011175615.GW19428@kernel.dk>
References: <fa.Ke90oacfRjgiI4x5LejzjssRBEg@ifi.uio.no> <200810111645.27847.bzolnier@gmail.com> <20081011150532.GU19428@kernel.dk> <200810111756.37278.bzolnier@gmail.com> <20081011170610.GA7574@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011170610.GA7574@gollum.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11 2008, Borislav Petkov wrote:
> On Sat, Oct 11, 2008 at 05:56:37PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Saturday 11 October 2008, Jens Axboe wrote:
> > > On Sat, Oct 11 2008, Bartlomiej Zolnierkiewicz wrote:
> > > > On Saturday 11 October 2008, Jens Axboe wrote:
> > > > > On Sat, Oct 11 2008, Borislav Petkov wrote:
> 
> [... ]
> 
> Don't you just love it when all gets resolved peacefully and
> everything is fine and dandy afterwards. I'm so happy we've
> straightened that one out. Just a final quick note which by no means
> is targetting to resparkle the discussion: I have another bug report,
> hm, well :), but still, the machine is a 8-core AMD Dell box (with the
> option of upgrading to 16 cores) which _is_ using ide-cd so, there are
> some people using that code, after all :). I'm sure those people will
> be happier when it scales to that many cores.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=11498.

Not to throw a monkey wrench, but I did add 'pushing data' to that IDE
statement. There is of course lots of systems still with a parallel
channel for things like atapi drives. But that is completely parallel to
the initial argument, those don't care a rats ass about scalability.
They care about it working, that is all.

-- 
Jens Axboe

