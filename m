Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbYABLPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbYABLPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 06:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYABLP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 06:15:28 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:54450 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbYABLP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 06:15:27 -0500
Message-ID: <477B7219.4080508@s5r6.in-berlin.de>
Date: Wed, 02 Jan 2008 12:14:33 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Andrew Morton <akpm@linux-foundation.org>
Subject: The perfect patch - Posting a patch series (was Re: [PATCH 06/12]
 pci : Use mutex instead of semaphore in driver core)
References: <20071229011057.GG2883@darkstar.te-china.tietoenator.com>	 <20071229025506.GL11638@parisc-linux.org>	 <477632A7.6050208@s5r6.in-berlin.de> <a8e1da0801011829p15da81dcw9db0f7cbb5444467@mail.gmail.com>
In-Reply-To: <a8e1da0801011829p15da81dcw9db0f7cbb5444467@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
> On Dec 29, 2007 7:42 PM, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> However, Dave's postings lack a References: header which refer to his
>> 00/12 posting.
[To let mail readers show it as a thread.]
>> (Also, a bonus in the 00/12 posting would be a listing of all patch
>> titles in the series and the total diffstat of the series,
[similar to the "git pull" requests from maintainers]
>> but nearly nobody does this.)
...
> andrew recommends not to use 00/xx introduction email in series
> in his "The perfect patch":
> http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt

"Please don't post [PATCH 0/n] messages" is a simplified short-hand for
"Please don't move information which we want to include into the SCM
changelog into a separate [PATCH 0/n] message".

There is nothing wrong with a 0/n posting per se.  But whenever you
write a 0/n posting, ask yourself:
  - Isn't the information I provide here necessary to keep around by
    somebody who takes my patch series into his quilt series or into his
    source repository?
  - Couldn't the information here be useful at a later point in time
    when people look into the mainline Linux history?
If "yes" or "maybe yes", then add this information to the changelogs in
the patches.  You can then leave the 0/n posting as is, or make it
briefer, or omit it entirely.

It is never necessary to post a 0/n message, because _everything_ which
could be said in this message can also be said in the i/n messages.
(Things which are not meant for the SCM changelog can be written after a
"---" delimiter line or other patch delimiters.)  However, it is
sometimes convenient to repeat or summarize some of the information from
the i/n messages in a 0/n message.  Think about convenience of the
_recipients_ though, not about the sender's convenience.

Generally, the 0/n message fulfills purposes very similar to "git pull"
messages:  They give a brief overview of what is coming up in the series
and how to handle it, and it adds redundant information about the
contents of the series (titles, authors, overall diffstat, whether it
supersedes an earlier series) as a verification for the recipient
whether he really got what the sender intended to get to him.  This is
to help detect mix-ups at the sender's or receiver's side.

PS:
Writing a changelog is almost never trivial.  Even if it seems trivial
to the patch author, the change may not be trivial from other
developers' and maintainers' perspective, or from the author's
perspective when he looks at his patch a few months later.  This also
means that there may very well be information in the 0/n message which
should also appear in the i/n messages, even if this information seems
obvious to the author.
-- 
Stefan Richter
-=====-==--- ---= ---=-
http://arcgraph.de/sr/
