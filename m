Return-Path: <linux-kernel-owner+w=401wt.eu-S1759053AbZBLNXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbZBLNXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 08:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbZBLNXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 08:23:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35413 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551AbZBLNXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 08:23:11 -0500
Date: Mon, 9 Feb 2009 00:49:46 +0100
From: Pavel Machek <pavel@suse.cz>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: ?ric Piel <Eric.Piel@tremplin-utc.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] lis3lv02d: support both one- and two-byte sensors
Message-ID: <20090208234946.GB1415@ucw.cz>
References: <1234309249-13672-1-git-send-email-giuseppe.bilotta@gmail.com> <499211D0.3090705@tremplin-utc.net> <cb7bb73a0902101551o30dde0aesaeba399f1ab732af@mail.gmail.com> <499213CD.6080903@tremplin-utc.net> <cb7bb73a0902101621r56224b46id9ab59dfe9501e3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb7bb73a0902101621r56224b46id9ab59dfe9501e3c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-02-11 01:21:32, Giuseppe Bilotta wrote:
> [removed git from the cc because that was a mistake]
> 
> On Wed, Feb 11, 2009 at 12:54 AM, Éric Piel <Eric.Piel@tremplin-utc.net> wrote:
> > BTW, now that this is working. Could you double check the correct axes set
> > up. In particular, is it x_inverted or y_inverted, and what about z axis...
> 
> Now that we have the 8 vs 16 bit mess sorted out, I re-checked and
> there my sensor definitely has the X (first) axis inverted, so the
> one-liner patch I sent at the beginning is still valid, at least as
> far as my laptop is involved. It might be that different dv5 Pavilions
> have different sensors though, which will make it quite harder to sort
> out.
> 
> I'd be interested in hearing from the other user (the one reporting
> inverted Y): rather than checking neverball, could he use plain jstest
> and see if the results match the Documentation or not?

Actuall 'watch cat position' is simplest way to test it.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
