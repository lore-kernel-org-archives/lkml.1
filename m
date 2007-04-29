Return-Path: <linux-kernel-owner+w=401wt.eu-S1161492AbXD2WGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161492AbXD2WGv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 18:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161498AbXD2WGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 18:06:51 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:53648 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1161492AbXD2WGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 18:06:49 -0400
Date: Sun, 29 Apr 2007 14:27:21 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Dave Jones <davej@redhat.com>
cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Markus Rechberger <mrechberger@gmail.com>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <20070429212756.GA14857@redhat.com>
Message-ID: <Pine.LNX.4.63.0704291403150.12401@qynat.qvtvafvgr.pbz>
References: <4630DB24.4030005@redhat.com>  <20070426201325.8a1ebda3.diegocg@gmail.com>
  <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> 
 <20070426224148.69b91b2e.diegocg@gmail.com> 
 <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> 
 <20070428195320.GZ3468@stusta.de>  <alpine.LFD.0.98.0704281529080.9964@woody.linux-foundation.org>
  <d9def9db0704281558r57460a6ft76bbddcc480058eb@mail.gmail.com> 
 <alpine.LFD.0.98.0704281629440.9964@woody.linux-foundation.org> 
 <20070429000542.GH3468@stusta.de> <20070429212756.GA14857@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007, Dave Jones wrote:

> On Sun, Apr 29, 2007 at 02:05:42AM +0200, Adrian Bunk wrote:
> > On Sat, Apr 28, 2007 at 04:40:31PM -0700, Linus Torvalds wrote:
> > >...
> > > What's the difference between bugzilla and lkml.org? Both have search
> > > buttons. Both archive the old stuff. Both can be pointed to.
> >
> > Mailing lists don't track bugs.
>
> There's no reason they can't.  Store them in folders 'fixed' 'pending'
> 'notabug' etc. Move mails between them when states change.
> reply-to them when necessary. Bounce them. Add people to Ccs. etc. etc.

and archive off the old reports into folders as well. While I don't think that 
closeing a report becouse it hasn't seen an update in a week is reasonable, 
closeing a report that hasn't seen an update or retest in a couple 2.6.x 
releases definantly is (this is a 4-6 month period at the rate of change in the 
kernel the odds are pretty good that the code is no longer the same at that 
point)

> The only remaining piece of the puzzle is "how does everyone see the
> states of the various pools", which could be solved in a number of
> ways, daily uploads to a place on kernel org for eg.

if people are interested in doing this it's not a technicly hard problem.

get bugs to a 'bug maintainer' e-mail address. this can either be a copy of the 
full lkml firehose, or volunteers who pull selected messages from the list, with 
a server that discards duplicates it's safe to have multiple people bounce the 
same message to the bug list, if they forward the message (to add a comment on 
who they think may need to work on it) then it will take manual weeding out of 
duplicates

have an IMAP server available for this address. make it read-only to the world 
and read-write to a list of volunteers who will sort the messages.

sort the messages into the different catagories, with a subfolder for each bug 
(note: the structure at this point is arbtrary, the volunteers can further 
orginise the folders)

with a good IMAP server you can add the address of the particular bug folder to 
the cc list if you want (bugs+drivers.ethernet.3com.123@kernel.org for a complex 
example) to have the follow-ups go directly into that folder.

now the problem with this is that developers would still have to look at it for 
an overview (the volunteers would still need to copy the developers when they 
create a new bug)

the cyrus mail server will scale well for this sort of thing, and I beleive that 
it can also export the mailboxes as news feeds as well (I haven't ever 
configured this so I can't say the exact details)

for searching, just make it available to google (I'm sure google would cooperate 
with this sort of thing to find the best way to do it)

the key is to find people to volunteer to do the sorting. the hosting of this is 
pretty simple (for that matter, I'll offer to host it if nobody else steps up)

David Lang

> Hell, you could store them in a git tree if it came to it.
> That would also solve the problem for those with an aversion
> to web browsers to see bugs :-)

git is not particulary good for searching the contents of things.

on that note, I wonder if google has a git:// search as part of theit git code 
project? if not they should.

