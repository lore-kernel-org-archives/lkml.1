Return-Path: <linux-kernel-owner+w=401wt.eu-S1758579AbYAYQE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbYAYQE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbYAYQES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:04:18 -0500
Received: from styx.suse.cz ([82.119.242.94]:57237 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753795AbYAYQER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:04:17 -0500
Date: Fri, 25 Jan 2008 17:04:15 +0100
From: Jan Kara <jack@suse.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, gorcunov@gmail.com
Subject: Re: [patch 25/26] mount options: fix udf
Message-ID: <20080125160415.GA1767@duck.suse.cz>
References: <20080124193341.166753833@szeredi.hu> <20080124193456.220272889@szeredi.hu> <20080125153044.GF28856@atrey.karlin.mff.cuni.cz> <E1JIQub-0002Bd-CW@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JIQub-0002Bd-CW@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 25-01-08 16:56:13, Miklos Szeredi wrote:
> >   Please use just 'int' for 'remount' option. We are slowly trying to
> > get rid of these strange things in UDF code so adding new ones isn't
> > desirable.
> 
> What's wrong with bool?
> 
> I'm not advocating mass replacements, but all new code _should_ use
> it, because it's a very useful and good type.
> 
> We are just not very much used to it yet, but don't tell me it's
> confusing to see a type like this ;)
  It's not so confusing but one really isn't used to it ;) But OK, I don't
mind that much...
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
