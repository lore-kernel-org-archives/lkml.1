Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbZD0XqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbZD0XqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 19:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZD0XqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 19:46:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45578 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073AbZD0XqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 19:46:06 -0400
Date: Mon, 27 Apr 2009 19:44:41 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Chris Frey <cdfrey@foursquare.net>, chrisw@sous-sol.org,
       linux-kernel@vger.kernel.org, smfrench@gmail.com
Subject: Re: fs/cifs/connect.c fix missing in latest stable
Message-ID: <20090427194441.10bac23d@tleilax.poochiereds.net>
In-Reply-To: <20090427221121.GD3036@sequoia.sous-sol.org>
References: <20090427205742.GA888@foursquare.net>
	<20090427221121.GD3036@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 15:11:21 -0700
Chris Wright <chrisw@sous-sol.org> wrote:

> * Chris Frey (cdfrey@foursquare.net) wrote:
> > Hi Chris,
> > 
> > The latest stable release 2.6.29.2 appears to be missing Jeff Layton's
> > fix in commit f083def68f84b04fe3f97312498911afce79609e (in Linus's tree).
> > 
> > I'm not the expert... I just noticed that this was mentioned on
> > full-disclosure: http://marc.info/?l=full-disclosure&m=123936563230145&w=2
> > (near the end of Andreas's post)
> 
> Yes, I think cifs developers are still doing cleanups in that area.
> Jeff?
> 

Yes, we are but they're pretty close. Some have already gone in and
some are still outstanding. Suresh J. has done the bulk of the work,
but there are a few additional fixes for other areas too.

I've been traveling for the last week, and took today off. My plan is
to get with Steve French tomorrow and finalize a set of fixes for his
tree that he can push to mainline and stable.

-- 
Jeff Layton <jlayton@redhat.com>
