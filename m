Return-Path: <linux-kernel-owner+w=401wt.eu-S933506AbXDFWFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506AbXDFWFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933536AbXDFWFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:05:48 -0400
Received: from smtp108.sbc.mail.re2.yahoo.com ([68.142.229.97]:30289 "HELO
	smtp108.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933506AbXDFWFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:05:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ljtUcZlLcpfYWdDyk2NQbFbxPXlFFUGApWAI2mETFOSe+z3q476ONo6uQUY9tqofaK611tu+qfBeZQYxfNbn7GGX+LhyT3MU0NKvs7gu7dLDQJksBzFOZEXtmbal4OvvZKhq5zkfNlK4SrxRg0hAkrwiabIuNH9ISKsE8leK3Os=  ;
X-YMail-OSG: A7cYefwVM1ljC95NUOtpTOANzSTNfhuiNpPMkuvGB22Slsdp2AIhX9eZGXNxEogA6S5oyuJiLxaTmO3iXJoSt7vL_e6i0swUk..Y3575x4FnDPPOI1fLNVFZRGffbzmlD_bOw60aVBbsvqU-
From: David Brownell <david-b@pacbell.net>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: coding style for long conditions
Date: Fri, 6 Apr 2007 15:05:41 -0700
User-Agent: KMail/1.7.1
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
References: <11757099691323-git-send-email-tony@atomide.com> <200704061405.50169.david-b@pacbell.net> <adabqi16v5a.fsf@cisco.com>
In-Reply-To: <adabqi16v5a.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704061505.41956.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2007 2:38 pm, Roland Dreier wrote:
> [I can't believe I'm stepping into an indentation flamewar, but here goes...]

At least you weren't the target of attacks there ... for daring to
actually follow the only published Linux style guide in that area!!


>  > Please change your coding style to conform to Documentation/CodingStyle.
>  > 
>  > 	***	Only indent with tabs!!		***

Having a style guide is supposed to mean, among other things, that
following it gives you "safe harbor".  Sigh.


> If you have a git tree handy, you can do "git show 68380b58" and see
> that Linus himself wrote:
> 
> 	if (get_wq_data(work) == cwq
> 	    && work_pending(work)
> 	    && !list_empty(&work->entry)) {

Yeah, well even the chief penguin wrangler has occasionally
admitted to human imperfections.  Not exclusively related to
the 0.99 kernel series, either ...  ;)

 
> I have to admit that I would have put the &&s at the ends of the
> previous lines rather than where Linus put them,

I approve in particular of that location:  beginning of line, where
they aren't masking the intent of the condition from a casual scan.
If there's a "right" place, that's it.

In particular, if you see lots of "&&" or "||" neatly lined up it
helps you understand something about when the conditional's body
will execute without needing to read to the end of every line.


> but... egads!  Linus 
> put spaces before the &&s to line them up nicely!
> 
> "more in the breach" and all that I guess...

Yeah, nobody likes style nazis.  On the other hand, it's rather
unusual to be the target of style nazism for actually following
the style guide!!  You'd think that maybe the folk objecting to
that style guide might maybe choose a more direct way to address
their particular frustrations, eh?  :)

- Dave


