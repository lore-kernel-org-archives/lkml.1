Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbXIRGfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbXIRGfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 02:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbXIRGfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 02:35:24 -0400
Received: from smtp116.plus.mail.re1.yahoo.com ([69.147.102.79]:33153 "HELO
	smtp116.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754251AbXIRGfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 02:35:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=s2vmroNJ9lQerIOgLv96pd4HFSXG8hW223eChJ5Q7CLGL85N9/kkjVqyKu+PPtpr1u05R3hBgC/JiQ59gZ/DPGFFf4MlwJth/k7yq3J+VpxGi+1+QjvzZ1/3xVgJBvJz7Wf0D/Wwu8R/ob/LNxNDqJ7I5HDNUbWnsrXzluzHSe4=  ;
X-YMail-OSG: A6KPmrAVM1mc2g1oYIRRY2fTwjNmgoleZtXh7ftvxTbcw54sxlcnPxcdkw.__lpmBjcDZPJl6g--
Date: Tue, 18 Sep 2007 08:34:43 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Satyam Sharma <satyam@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] unify DMA_..BIT_MASK definitions: v1
Message-ID: <20070918063443.GB14903@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070918042919.GA8998@gollum.tnic> <20070918055803.GB4640@rhun.haifa.ibm.com> <46EF69B1.8020801@goop.org> <20070918060854.GA14903@gollum.tnic> <alpine.LFD.0.999.0709181145060.14771@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.999.0709181145060.14771@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 11:46:40AM +0530, Satyam Sharma wrote:
> Hi Borislav,
> 
> 
> On Tue, 18 Sep 2007, Borislav Petkov wrote:
> 
> > On Mon, Sep 17, 2007 at 11:01:21PM -0700, Jeremy Fitzhardinge wrote:
> > > Muli Ben-Yehuda wrote:
> > > >> +#define DMA_64BIT_MASK	DMA_BIT_MASK(64)
> > > >>     
> > > >
> > > > This one does not do what you mean. You need an explicit mask or a
> > > > ~0ULL here.
> > > 
> > > Yeah, I was just about to comment on it.  Its possible the compiler
> > > might decide to shift by x%64 = 0.
> > > 
> > >     J
> > ups, i knew that this might be a corner/boundary case. Thanks, updated patches
> > follow...
> 
> Please fold all three patches into a single patch in the updated series,
> otherwise git bisecters falling in between these patches will see the
> "redefinition ... previous definition was here" warnings of gcc ...

Will do later today, thanks.
-- 
Regards/Gruﬂ,
    Boris.
