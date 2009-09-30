Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbZI3MDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbZI3MDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZI3MDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:03:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46522 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbZI3MDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:03:07 -0400
Date: Wed, 30 Sep 2009 14:02:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: No more bits in vm_area_struct's vm_flags.
Message-ID: <20090930120202.GB1412@ucw.cz>
References: <4AB9A0D6.1090004@crca.org.au> <Pine.LNX.4.64.0909232056020.3360@sister.anvils> <4ABC7FBC.4050409@crca.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABC7FBC.4050409@crca.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Does TuxOnIce rely on CONFIG_MMU?  If so, then the TuxOnIce patch
> > could presumably reuse VM_MAPPED_COPY for now - but don't be
> > surprised if that's one we clean away later on.
> 
> Hmm. I'm not sure. The requirements are the same as for swsusp and
> uswsusp. Is there some tool to graph config dependencies?

I don't think swsusp was ported on any -nommu architecture, so config
dependency on MMU should be ok. OTOH such port should be doable...

								Pavel 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
