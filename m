Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbYFTHcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbYFTHcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 03:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbYFTHc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 03:32:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3618 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751240AbYFTHc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 03:32:28 -0400
Date: Wed, 18 Jun 2008 21:27:59 +0200
From: Pavel Machek <pavel@suse.cz>
To: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Cc: "'Jason Baron'" <jbaron@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 0/8] dynamic debug
Message-ID: <20080618192758.GB4243@ucw.cz>
References: <20080613185733.GA8813@redhat.com> <009201c8cf58$58909080$09b1b180$@css.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009201c8cf58$58909080$09b1b180$@css.fujitsu.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-06-16 11:26:12, Takashi Nishiie wrote:
> Hi.
> 
> Jason Baron wrote:
> >Each kernel sub-system seems to have its own way of dealing with 
> >debugging statements. Some of these methods include 'dprintk', 
> >'pr_debug', 'dev_debug', 'DEBUGP'. There are also a myriad of 
> >ways of enabling these statements. 
> 
>  I propose to replace 'Pr_debug', 'Dev_debug', and 'DEBUGP' with 
> kernel markers. SystemTap is used for the output of the log.  

...which would make them unusable. You down want people trying to
debug kernel problems install/configure systemtap...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
