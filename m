Return-Path: <linux-kernel-owner+w=401wt.eu-S935359AbYEUOcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935359AbYEUOcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758812AbYEUOc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:32:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:12165 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049AbYEUOcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:32:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tsJEpbBPCIQW2UvIbmjncRhAlNghT2oUhjQ5wpxXY2YSHZM8h5qQJaysMZ0Q6Chzt40Ej9GxUF5qWxw3tN5d4U5FrxuDjmEyYz/wlhaSLIVNf/+sYmg4QtnqTGtg/l91JFFsd9a/fHwsLnSWjFYq0HDWrAWfKyPdmQb1stEWZc0=
Message-ID: <170fa0d20805210732s24f2c188i75ab2ab2dab5aeb5@mail.gmail.com>
Date: Wed, 21 May 2008 10:32:25 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Tarkan Erimer" <tarkan@netone.net.tr>
Subject: Re: Suggestion About Kernel Releases
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Arjan van de Ven" <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <48342B19.9040407@netone.net.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48341ED5.7060508@netone.net.tr>
	 <20080521063855.0bdb441c@infradead.org>
	 <84144f020805210648y43efb024w8e2f28e62894b1d@mail.gmail.com>
	 <48342B19.9040407@netone.net.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 10:00 AM, Tarkan Erimer <tarkan@netone.net.tr> wrote:
> Pekka Enberg wrote:
>
> > On Wed, 21 May 2008 16:08:37 +0300, Tarkan Erimer <tarkan@netone.net.tr>
> wrote:
> >
> >
> > >
> > > > After long discussions about kernel release methodology, an idea has
> > > > came to ( Any comments welcomed :-) ) my mind :
> > > >
> > > >
> > >
> >
> > On Wed, May 21, 2008 at 4:38 PM, Arjan van de Ven <arjan@infradead.org>
> wrote:
> >
> >
> > > what would you want to accomplish with your idea?
> > >
> > >
> >
> > And how is it different from what we do now, modulo the -test1 postfix
> > to the name?
> >
> >
>
>  Please see my reply to Arjan's post.

I think you're missing Arjan and Pekka's point: your proposal doesn't
_really_ offer any change to the current procedure.  It might make you
feel more warm and fuzzy but in practice:
1) Linus would still release a kernel (be it to -testX or "final")
when he and others feel it is time
2) The stable team will track fixes and release stable kernels as needed

The only thing that is different in your approach is the "final"
release would theoretically be more well tested.  Unfortunately that
is not a valid assumption because the wider Linux audience likely
won't embrace the latest kernel until it is "final" anyway.  This
delayed uptake can/will result in early stable fixes.

Again, no real change... we know that the "final" release that Linus
makes _could_ have some minor oversight that will be fixed fairly
quickly by the stable team.

Mike
