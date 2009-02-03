Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbZBCN4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbZBCN4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbZBCN4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:56:05 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45079 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbZBCN4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:56:04 -0500
Date: Tue, 3 Feb 2009 14:55:54 +0100
From: Pavel Machek <pavel@suse.cz>
To: etienne <etienne.basset@numericable.fr>
Cc: airlied@linux.ie, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: [2.6.29-rc3][Suspend regression][DRM, RADEON]
Message-ID: <20090203135554.GA1560@ucw.cz>
References: <4971DFA5.2000304@numericable.fr> <4974EB02.4060303@numericable.fr> <4980D58F.8010105@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4980D58F.8010105@numericable.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Are there any patch i could try?
>> Is it possible to run a git bisect excluding all drm commits to find  
>> the other bug?
> hello,
>
> I tried 2.6.29-rc3, and things got a little better. Suspend/resume  
> results in a garbage video, but now i have access to my desktop via SSH  
> after resume; so only X/drm seems to be broken after resume.
> I (re)did  the stupid replace of driver/gpu/drm and include /drm by  
> 2.6.28 files, and have now been able to suspend/resume a few time.
> So in rc1-rc2 I had multiple bugs preventing me from STR, now there's  
> only one left in DRM. My initial bisect was perhaps not so useless after  
> all?
>
> Is it possible to run a bisect only for DRM changes? are there any logs,  
> additionnal info  I can provide?

I think git bisect can do that, yes. 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
