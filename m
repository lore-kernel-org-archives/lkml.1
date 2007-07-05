Return-Path: <linux-kernel-owner+w=401wt.eu-S1762641AbXGEXup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762641AbXGEXup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759255AbXGEXui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:50:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:8066 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759102AbXGEXuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:50:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r2nc3IiBpIdeifxc0VnXfwjPoifgxj8B+fRN0gS4UFA6n42rto1ju+zLxJhRshj1KwJHputXqyCbUFyOFIogbhKCtmJSCUe3zlZSqlejUMM4Mm+fr5mkBX6sxeeAvSKgb5TbnEdKkEW6zW6/a/oesxrNMwodxbE31xXc0TYIPI8=
Message-ID: <9a8748490707051650o16a260fexf9b8d62c4a65db4f@mail.gmail.com>
Date: Fri, 6 Jul 2007 01:50:36 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [git pull][resend] Input updates for 2.6.22-rc7
Cc: "Dmitry Torokhov" <dtor@insightbb.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0707051618040.9434@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707050111.43327.dtor@insightbb.com>
	 <alpine.LFD.0.98.0707051556000.9434@woody.linux-foundation.org>
	 <alpine.LFD.0.98.0707051618040.9434@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 5 Jul 2007, Linus Torvalds wrote:
> >
> > It says your user-agent is "Kmail", and maybe there is some way to fix it.
> > And if kmail is correct, please make a bug-report to the kmail people.
>
> Ok, googling for kmail, I think it really is kmail doing it, because I
> find others complaining about the same idiocy.
>
> Btw, the others who noticed this weren't _nearly_ as polite as I am about
> kmail.
>
> Apparently kmail - at least when cutting-and-pasting - will actually turn
> every other space into an NBSP for some internal idiotic reason. So even
> if you _originally_ had 8 spaces, Kmail will apparently corrupt your data
> when cutting-and-pasting according to that other report I saw.
>
> Please stop using kmail, or ask for it to get fixed.
>
Or just configure it differently.  I use kmail sometimes (either that
or pine) and with a little config tweaking (and a few rules of thumb
about use) it can actually be made to behave resonably fine.

Here are a few tips;
  - Don't cut'n'paste stuff into kmail
  - Go to Settings --> Configure KMail, select Composer, remove the
checkmark from "Word wrap at column ...".
  - Go to Settings --> Configure KMail, select Composer, go to the
Charset tab, make the list read us-ascii, iso-8859-1   - just listing
those two (in that order) seems to generate working mails.
  - Go to Settings --> Configure KMail, select Accounts, go to the
Sending tab, make "Message property" be "Allow 8-bit".

When writing a new message, check the Options menu, make sure Wordwrap
is not enabled and that Encoding is us-ascii or iso-8859-1 (or
possibly something else) - the auto-detect option seems to sometimes
get things wrong.

When inserting a patch or similar into a mail, use Message-->"Insert File"


> I'm constantly surprised by just how _many_ ways MUA's find to screw up.

'pine' actually seems to work pretty damn well once you disable the
flowed-text "feature".

> It's not like they seem to all have some stupid bug. It's more like they
> seem to all have willfully added code explicitly to mess up the content of
> email, often with the goal of making it "look" right, even if it's crap.
>
> In this case, it means that you cannot cut-and-paste simple ASCII text,
> because Kmail messed up.
>
Yeah, email is old, and there are too many ways to do things, too many
conflicting RFC's, compeeting commercial implementations etc etc etc -
the whole thing could do with a from-scratch re-implementation (as if
that's going to happen)...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
