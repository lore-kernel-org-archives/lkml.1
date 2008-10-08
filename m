Return-Path: <linux-kernel-owner+w=401wt.eu-S1755065AbYJHQqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbYJHQqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 12:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYJHQqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 12:46:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46266 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752788AbYJHQqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 12:46:22 -0400
Date: Wed, 8 Oct 2008 12:56:11 +0200
From: Pavel Machek <pavel@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH 2/3] Fix fsync livelock
Message-ID: <20081008105611.GA1396@ucw.cz>
References: <Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com> <20081001225404.4e973465.akpm@linux-foundation.org> <Pine.LNX.4.64.0810051814060.23248@hs20-bc2-1.build.redhat.com> <20081005153306.7e644c9f@infradead.org> <Pine.LNX.4.64.0810051901190.31780@hs20-bc2-1.build.redhat.com> <20081005160724.54dd1a27@infradead.org> <Pine.LNX.4.64.0810051910580.663@hs20-bc2-1.build.redhat.com> <20081005162847.7bf0ead1@infradead.org> <Pine.LNX.4.64.0810051949290.5798@hs20-bc2-1.build.redhat.com> <20081005173019.0a358b09@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005173019.0a358b09@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-10-05 17:30:19, Arjan van de Ven wrote:
> On Sun, 5 Oct 2008 20:01:46 -0400 (EDT)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > I assume that if very few people complained about the livelock till
> > now, very few people will see degraded write performance. My patch
> > blocks the writes only if the livelock happens, so if the livelock
> > doesn't happen in unpatched kernel for most people, the patch won't
> > make it worse.
> 
> I object to calling this a livelock. It's not. 

8 hours of process in D state is a livelock. And we can do minimal fix
here, this almost never happens in real life anyway.

Latency imposed of writer should not be a problem...
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
