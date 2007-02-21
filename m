Return-Path: <linux-kernel-owner+w=401wt.eu-S932647AbXBUWIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647AbXBUWIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932637AbXBUWIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:08:39 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:31000 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647AbXBUWIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:08:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HE12N4JR1945yBQrVJXzK8FU7jIpSP3CjXIQvC2w4iHW5yScH4EWU+3OVjatayxWBHPJBEo5wwWeOIXuj/M3/pnTdokaNlqco3V0iK7uV+gsgLAR6cC+yz+dSRO94h6EuKEx1wjMn8I6I8DSAPfVacFqaQVKRosZzNqCgOI87uA=
Message-ID: <f2b55d220702211408r7954d5dar2c59e1e679316811@mail.gmail.com>
Date: Wed, 21 Feb 2007 14:08:36 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: davids@webmaster.com, "v j" <vj.linux@gmail.com>
Subject: Re: GPL vs non-GPL device drivers
Cc: trent.waddington@gmail.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       "Neil Brown" <neilb@suse.de>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com>
	 <MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, it's quite clear under US law what a derivative work is and
what rights you need to distribute it, and equally clear that
compiling code does not make a "translation" in a copyright sense.
Read Micro Star v. Formgen -- it's good law and it's funny and
readable.

I've drafted summaries from a couple of different angles since VJ
requested a "translation into English", and I think this is the most
coherent (and least foaming-at-the-mouth) I've crafted yet.  It was
written as an answer to a private query to this effect:  "I write a
POP server and release it under the GPL.  The Evil Linker adds some
hooks to my code, calls those hooks (along some of the existing ones)
from his newly developed program, and only provides recipients of the
binaries with source code for the modified POP server.  His code
depends on, and only works with, this modified version of my POP
server.  Doesn't he have to GPL his whole product, because he's
combined his work with mine?"

This is a fundamental misconception.  A <<product>> is not a "work
of authorship".  Copyright is about "works of authorship" and cannot
be used to allow or disallow behavior based on whether you have
<<combined>> two things at an engineering level to make a product.  A
contract can be used to allow or disallow, and assign penalties to,
all sorts of things, and the GPL is an "offer of contract"; but its
plain text does _not_ disallow this <<combination>> -- largely because
the drafter was trying to put one over on you and me by pretending that
he could do that without recourse to contract law.

The fact that your Evil Linker's program will not do anything
interesting without your program is no more relevant than the fact
that Borland's spreadsheet program will not do anything interesting
without a spreadsheet document loaded.  Borland's interest lay in
making their macro language compatible with Lotus's so that users
didn't have to rewrite their documents from scratch.  The Evil
Linker's interest lies in making their program compatible with other
clients of your POP server so they don't have to rewrite your POP
server from scratch.  Borland won in court, and so will the Evil
Linker.  IANAL, TINLA.

Now, Borland _almost_ lost at the Supreme Court level.  Why?  Because
while they had a good case that it wasn't practical to copy the 1-2-3
macro language without copying its entire user interface, that gets
awfully close to the sort of expression that copyright is supposed to
protect.  You can take a picture of a skyscraper and sell copies of
that picture, not because it isn't in some sense an infringement on
the architect's copyright, but because it's "fair use" -- mostly
because it doesn't interfere with the architect's ability to make
money licensing _architectural_ replicas of her work.  When you take a
screenshot of a spreadsheet, you're on safe ground; but if you use
that screenshot to clone the spreadsheet, you're pushing your luck.

Borland won, sort of, when the Supremes split 4-4 (one was out sick or
recused or something).  If you want to know why, you can get hold of a
transcript of the oral argument before the Supreme Court, which is
mostly in plain English and about half debate between the Justices
about where they ought to draw the line.  For an example where
screenshots can be over the line, and where even unlicensed
distribution of data files can be held to infringe the copyright on
the program that reads them, read Micro Star v. Formgen (9th Circuit).
 That involved a very different theory though, infringement on the
"characters and mise en scene" of a fictional work (Duke Nukem 3D),
and will not avail you against the Evil Linker.  All of this stuff is
covered in Lexmark v. Static Control (6th Circuit, cert. denied) --
the law of the land throughout the U. S. of A.

But wait, you say -- the Evil Linker modified, copied, and distributed
my POP server too!  That makes him subject to the terms of the GPL.
And you're right; but to understand what that means, you're going to
need to understand how a lawsuit for copyright infringement works.
The very, very, very concise version is:

You claim "copyright infringement".
He claims "copyright license" -- "acceptance through conduct" of a
"valid offer of contract".
You claim conduct outside the "scope of the license".
He claims the terms about distributing modified versions together with
source code are "covenants of return performance", which he duly
performed.
You claim the license covers the whole <<work based on the Program>>,
including his application.
He points out that <<work based on the Program>> is explicitly defined
in GPL Section 0 to be a "derivative work under copyright law", and
that while the paraphrase following this overstates the extent of the
"derivative works" category, a raft of case law says that his program
is not a "derivative work" of yours.  Furthermore, it would be
"contrary to the public interest" to allow a "contract of adhesion in
rem" to disallow the "universal industry practice" of <<aggregating>>,
for engineering purposes, many differently licensed works on common
media, whether or not they <<function together>> in different and
better ways than they would without one another's presence.
He moves for "judgment as a matter of law", saying that the skeletal
outline of facts already on the table is sufficient to demonstrate
that none of your "legal theories" can possibly succeed.

Judge agrees with him, saying that the parties have formed an
incontestably "valid contract", contracts must be "construed against
the offeror" in the presence of ambiguity, and any "defects in
performance" that you might be able to demonstrate would almost
certainly not "strike to the heart of the contract".  Therefore
you have no grounds for "rescission", and the license stands with
respect to the original work and the "modified", <<compiled to object
code>>, "copied", and "distributed" version created by the Evil
Linker.  No other "infringing work" has been created, because the
<<combination>> of your work and his is neither a "derivative work"
nor a "copyrightable compilation", merely a "parcel of goods".  You
have not been "harmed" in any way that you have not already "waived
the right to sue" for, so you have no recourse under "tort"; you have
no "contract in personam", so you cannot sue for "breach of contract";
you owe "costs" to the court and "cost of defense" to the defendant.

Judge sends you home, a sadder but a wiser man.  Or, if not wiser,
preparing to cost yourself a lot more money by appealing the judgment.

Everything in "double quotes" in that analysis is a legal term of art,
_throughout_the_developed_world_.  Everything in <<angle quotes>> is
not.  (I am not a lawyer, this is not legal advice.)  Anyone, even a
Justice of the US Supreme Court, who tells you that he has the
authority to bend the meaning of a legal term of art, in the presence
of a mountain of applicable case law, is a shyster and a poltroon.
When he's been doing it for twenty years, ten of them with the
ostensible authority of a professor of law and legal history, and
making $500K a year or so doing it, he's a charlatan and a racketeer.

Cheers,
- Michael
