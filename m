Return-Path: <linux-kernel-owner+w=401wt.eu-S965088AbXHLVLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965088AbXHLVLW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 17:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759448AbXHLVLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 17:11:09 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:52520
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756462AbXHLVLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 17:11:07 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/5] Add some missing Documentation/*/00-INDEX files
Date: Sun, 12 Aug 2007 16:11:02 -0500
User-Agent: KMail/1.9.6
Cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200708120045.03032.jesper.juhl@gmail.com> <200708121454.15856.rob@landley.net> <46BF6AE2.9070105@s5r6.in-berlin.de>
In-Reply-To: <46BF6AE2.9070105@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708121611.02971.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 August 2007 3:17:38 pm Stefan Richter wrote:
> > This heuristic seems to need about as much cleanup as just fixing
> > 00-INDEX.txt in all the directories.
>
> I didn't think of heuristics but rather of a style guideline.  Maybe
> prepend this metadata line with "Subject: " or so to distinguish it from
> data.

That's just extra markup for me to filter out.  Either the first line nonblank 
has a special meaning or it doesn't.  Currently, it doesn't.

> What's the difference to 00-INDEX?  It's inline.  Hence,
>   - as soon as a majority of files have that header, authors of new
>     files will start to provide that header automatically.  Or am I too
>     optimistic?

You're too optimistic, but if it's something we can check automatically we can 
find and fix instances that don't.  (Although in this case "automatic" means 
we generate the index, put it on the web, and either we notice mistakes or 
people point them out to us.)

>   - it's a little bit faster to create these headers than to add them
>     to 00-INDEX:  Just move the existing title to the top.

You are aware that some of the files in Documentation aren't text, right?  
There's example code in C, there's docbook, there's a gif and an xpm...

What variant of "fast" do you mean?  Processing the entire directory takes a 
fraction of a second on my laptop.

I'm not really invested in 00-INDEX, but I point out that it currently exists 
and I've indicated a willingness to do work to update it.  If you want to do 
your own work to update something else, be my guest.  I'll be over here.

> There could also be "From: " and/or "Cc: " headers for authorship and
> maintainership metadata.

You're adding complexity again.  Why are you adding complexity?

> (Of course maintainership metadata could also 
> go into extra files like 00-INDEX or MAINTAINERS.

00-INDEX is a bad place for it, and MAINTAINERS hasn't go the granularity.

> Authorship metadata 
> of more recent documentation files is actually available in the source
> control system.)

I was wondering if this would be noticed...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
