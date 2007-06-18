Return-Path: <linux-kernel-owner+w=401wt.eu-S1765383AbXFRUAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765383AbXFRUAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762464AbXFRUAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:00:01 -0400
Received: from keil-draco.com ([216.193.185.50]:50285 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761487AbXFRUAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:00:00 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: mea culpa on the meaning of Tivoization
Date: Mon, 18 Jun 2007 15:59:39 -0400
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>, Rob Landley <rob@landley.net>,
       Bron Gondwana <brong@fastmail.fm>, Al Viro <viro@ftp.linux.org.uk>
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br> <200706172115.20285.dhazelton@enter.net> <orsl8paxl0.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orsl8paxl0.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706181559.40320.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 June 2007 15:09:47 Alexandre Oliva wrote:
> On Jun 17, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> > On Sunday 17 June 2007 19:11:13 Alexandre Oliva wrote:
> >> Let me start with an example: I bought a wireless router some time
> >> ago, and it had a GNU+Linux distribution installed in it.  No source
> >> code or written offer for source code, though.
> >
> > Just want to point out that, when I read this, my reaction was
> > "But... That is a direct violation of the GPLv2. No specific reading
> > of the license needed."
>
> Yes.  Anyone feels like enforcing the GPLv2 in Brazil?  I can even
> recommend lawyers that speak English reasonably well and are somewhat
> familiar with the GPL, and I've already tracked the distribution chain
> back to the initial infringer.  Harald is aware of the issue, but
> AFAIK he's decided not to pursue that yet.

I don't know if I have the right. None of the code is mine - the fact that 
they are in violation of the license is not in question (I trust your word on 
this), but it is the licensor who has the right to press charges. (I will 
check with the lawyers and law professionals I know, because the GPL makes no 
statements about the legal jurisdiction under which violations will be tried. 
It might be that I actually can file suit under Brazillian law)

> >> Now, if I called the vendor next day and asked for the source code,
> >> and they responded "sorry, I can't give you that.  I threw it all
> >> away, such that I wouldn't be able to give it to you.", they would
> >> still be disrespecting my freedoms, as well as the license, right?
> >
> > Yes, they would. They are distributing a modification
>
> There's no reason to assume it's a modification.  They're distributing
> a copy, and that's enough.

Bad word choice on my part. Of course you are correct.

> >> So, if I called them to ask how to install and run modified versions
> >> of the GPLed programs, and they responded "sorry, I can't give you
> >> that.  I threw it all away, such that I wouldn't be able to give it to
> >> you.", they would still be disrespecting my freedoms, as well as the
> >> license.
> >
> > Not even the GPLv3dd4 - because they don't have the information
> > anymore either. If, however, they still retained the information -
> > in any form - they would be violating the GPLv3dd4.
>
> I'm told by the authors of GPLv3dd4 that this case is not meant to be
> permitted.  I suppose they're going to change the wording, or at least
> the rationale for it.

Okay. So its possible to change whats running on the hardware - but even 
though nobody has the information needed to do it, it's a violation. Hrm... I 
can see some valid reasoning behind this, but it'll take creative legalese to 
make sure that things like (EE)PROMS are properly covered.

> > The GPLv2 doesn't make the actions described above - "how to install and
> > run" - a license violation.
>
> This is true.  They didn't have any such duty, under the GPLv2.
>
> However, if I figured that out by myself, but found that I was unable
> to run a modified version because something in there checks for a hash
> computed over the program I'd like to modify, and refuses to run it
> because of the hash, then the hash is effectively part of the program,
> and they haven't provided me with the corresponding sources of that
> portion of the program.

"Effectively" - yes, that is the perfect way to describe it. And even though 
it isn't directly part, a situation like that should be covered. (In other 
words, if this was the way the "tivoization" section was written to make 
this "effectively part of the work" bit the focus a lot of my objections to 
it would be nullified. Give me a few hours to work on some solid and 
unambiguous language and I'll send something your way for review) 

> I know you don't want that to be true, and a court might actually
> decide your way some day.  But until then, your claim that this is
> permitted by the GPL is just as good as mine that it's not.  And I
> really mean "just as good", since my claim is in line with the stated
> purpose of the authors of the GPL, and yours is in line with their
> opinion (according to others, I don't think I've got this straight
> from them) as to whether the license effectively prohibits this
> practice.

Agreed. As Linus pointed out, we've been arguing over opinions and that's 
pointless. The only thing to do when someone states an opinion is to nod and 
accept it.

> > Then anyone using GPLv3'd software to drive WiFi devices, radio (HAM
> > radio) networks, etc - in the US, at least - isn't allowed to do such. US
> > Law makes some provisions of the GPLv3 illegal to comply with. Thanks to
> > section 6 of the GPLv3 that invalidates the rights granted under the
> > license.
>
> Actually, this is false.  Not only because of the ROM provisions in
> the GPLv3, but because the law requirements aren't anywhere as strict
> as the WiFi vendors who want to disrespect your freedoms want you to
> believe.

Perhaps. I haven't looked into the specific regulations in over a year, so my 
memory may be failing me entirely.

> > What the GPLv3 has done is take away options they might otherwise
> > have had.
>
> It doesn't.  Authors can always grant these options separately if they
> want to.  Authors can always choose GPLv2 if they want to.

Okay. I think that someone pointed out a problem with the "optional grant" 
idea, but I can't remember the specifics and don't feel like digging through 
the 500 or so posts that make up this discussion.

> GPLv3 is an option for those who want to defend freedoms, even if they
> don't share the perception that this is a moral and ethical issue.  If
> they're in it only for the self benefits, that's fine, GPLv3 can get
> them that, even better than GPLv2 could, in spite of the short-sighted
> claims to the contrary.

If this is your opinion, then run with it. My opinion on the matter is the 
opposite - that the GPLv2 does the job in a better way - but, well, that's my 
opinion. (and like my mother used to say - "Opinions are like assholes. 
Everyone has one, and the only one that doesn't stink is your own.")

> > If one of the goals of the FSF is to force proprietary software into
> > a minority then its just done damage to that goal.
>
> That's not the goal.

I didn't say it was "the goal", I said "one of the goals". I'm the first to 
admit when I'm wrong, but in this case I've read interviews with RMS where he 
has said that one of the reasons he founded the FSF was to marginalize 
proprietary software. (No, I don't know where this was - the interview was 
done several years ago)

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
