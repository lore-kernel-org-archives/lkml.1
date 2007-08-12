Return-Path: <linux-kernel-owner+w=401wt.eu-S938182AbXHLUSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938182AbXHLUSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbXHLUSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:18:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48793 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208AbXHLUSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:18:03 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46BF6AE2.9070105@s5r6.in-berlin.de>
Date: Sun, 12 Aug 2007 22:17:38 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Jesper Juhl <jesper.juhl@gmail.com>, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] Add some missing Documentation/*/00-INDEX files
References: <200708120045.03032.jesper.juhl@gmail.com> <9a8748490708121010q7fe3bfbx8d4d8b997ed5fc72@mail.gmail.com> <46BF44A6.7010401@s5r6.in-berlin.de> <200708121454.15856.rob@landley.net>
In-Reply-To: <200708121454.15856.rob@landley.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> On Sunday 12 August 2007 12:34:30 pm Stefan Richter wrote:
>> Or use the first line of each text file to describe what the file is about.
...
> This heuristic seems to need about as much cleanup as just fixing 00-INDEX.txt 
> in all the directories.

I didn't think of heuristics but rather of a style guideline.  Maybe
prepend this metadata line with "Subject: " or so to distinguish it from
data.

What's the difference to 00-INDEX?  It's inline.  Hence,
  - as soon as a majority of files have that header, authors of new
    files will start to provide that header automatically.  Or am I too
    optimistic?
  - it's a little bit faster to create these headers than to add them
    to 00-INDEX:  Just move the existing title to the top.

There could also be "From: " and/or "Cc: " headers for authorship and
maintainership metadata.  (Of course maintainership metadata could also
go into extra files like 00-INDEX or MAINTAINERS.  Authorship metadata
of more recent documentation files is actually available in the source
control system.)

>> And BTW, if authors insist on "Last Updated:", make it a header rather
>> than a footer.  Increases the chance that submitters remember to update it.
> 
> Why not just use the source control system to review the actual revision 
> history of the file?

Just to clarify:  I'm *not* one of those who want the date in there.
-- 
Stefan Richter
-=====-=-=== =--- -==--
http://arcgraph.de/sr/
