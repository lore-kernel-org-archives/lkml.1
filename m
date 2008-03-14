Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbYCNTab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbYCNTab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYCNTaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:30:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44500 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYCNTaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:30:23 -0400
Date: Fri, 14 Mar 2008 20:30:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Romano Giannetti <romanol@upcomillas.es>
Cc: Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl,
       len.brown@intel.com, stable@kernel.org
Subject: Re: fix aperture vs. suspend problem
Message-ID: <20080314193049.GA24646@elf.ucw.cz>
References: <20080313100531.GA3399@elf.ucw.cz> <20080313153248.f43bbce3.akpm@linux-foundation.org> <20080313223845.GC8115@elf.ucw.cz> <1205482463.4561.3.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205482463.4561.3.camel@localhost>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-03-14 09:14:23, Romano Giannetti wrote:
> 
> 
> On Thu, 2008-03-13 at 23:38 +0100, Pavel Machek wrote:
> > On Thu 2008-03-13 15:32:48, Andrew Morton wrote:
> > > [...] 
> > > This is also needed in 2.6.24, perhaps earlier?
> > 
> > It seems to only trigger on >3GB boxes, during swsusp. People are not
> > normally suspending those big boxes. I do not think this is worth
> > backporting.
> 
> Here vendors are starting to sell x86_64 laptops with 4GB ram in the
> *default* configuration --- so I think that yes, it should be
> backported, at least to 2.6.24 (which will be heavily shipped by distros
> this year, I suppose).

Ok, if you hit the problem, you can do the backport. Subject is wrong,
it hits hibernation, not suspend (sorry), and I'm not yet sure if I
fixed all the related problems. Testing welcome.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
