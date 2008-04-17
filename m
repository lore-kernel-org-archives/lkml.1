Return-Path: <linux-kernel-owner+w=401wt.eu-S934425AbYDQRW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934425AbYDQRW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761799AbYDQRWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:22:17 -0400
Received: from rv-out-0708.google.com ([209.85.198.241]:32640 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761614AbYDQRWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:22:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nopruAsJ72C4bT8eyynHUke5hYKgfXQuwwSOQiVzQ46ttjvgh/mtInTeXzfK4cZKpTH09tyWfdze6EPkWtPc3vehP4NpPFeDJHSWvhmjSxu3qJmj4IzuK9n8G0Y0hkQiAYFgdJJ4O6hmQFaJxwnh/olwZKc9yz5laRIQYN7HPYI=
Subject: Re: [PATCH-mm 1/3] mac80211: tkip.c use get/put_unaligned helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Kosina <jkosina@suse.cz>, Jiri Benc <jbenc@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
In-Reply-To: <1208450454.4066.20.camel@johannes.berg>
References: <1208370570.11920.107.camel@brick>
	 <20080417105859.45092413@griffin.suse.cz>
	 <Pine.LNX.4.64.0804171102370.19002@twin.jikos.cz>
	 <1208450454.4066.20.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 17 Apr 2008 10:22:26 -0700
Message-Id: <1208452946.17196.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-17 at 18:40 +0200, Johannes Berg wrote:
> > > I guess you are going to push this stuff through -mm altogether, right? 
> > > I can hardly take this into my tree right now, as the helpers are not in 
> > > Linus' tree yet.
> > 
> > yeah, sorry, that's been confusing a few people.
> > 
> > Strictly I'd merge the core infrastructure and then send the dependent 
> > patches into the relevant maintainers.  But that can mean than we 
> > needlessly miss the merge window, so it's most parctical to send along an 
> > acked-by and I'll merge the dependent patch directly with the appropriate 
> > ordering.
> 
> I guess what Jiri (Benc) is saying that *I* should ack them, not him.
> Jiri (Benc), maybe you care to move yourself down in the maintainers
> file?

I'll resubmit a cleaned up series anyways once the unaligned access
helpers get into mainline, so don't worry too much about this set I
suppose.

Cheers,

Harvey

