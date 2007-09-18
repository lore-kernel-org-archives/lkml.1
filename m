Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbXIRGJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbXIRGJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 02:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbXIRGJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 02:09:34 -0400
Received: from smtp102.plus.mail.re1.yahoo.com ([69.147.102.65]:24476 "HELO
	smtp102.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751114AbXIRGJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 02:09:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=uZWy+jscMxDm7hmd15ECprJgzcjdP2+lm/iBAxo9PEjJCA7G8H8zNIILbgABnjPbWVQ7uGh9nD13f2FjW4PHyBQQsPyvOSPLp6SOFDaI05IOMHu9UaGg35K9Hmv8xOi8DQWEGfkcbyXazb3mc4zK+Biq9sonl/btLUuUnUZtl8E=  ;
X-YMail-OSG: LaNlCIcVM1mzDH05vSaoIJedpJxDgopRVtVr3eUKyZLGMAFrqKRHHRjW8Flv2.I26LK4g.g_RA--
Date: Tue, 18 Sep 2007 08:08:54 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] unify DMA_..BIT_MASK definitions: v1
Message-ID: <20070918060854.GA14903@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070918042919.GA8998@gollum.tnic> <20070918055803.GB4640@rhun.haifa.ibm.com> <46EF69B1.8020801@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46EF69B1.8020801@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:01:21PM -0700, Jeremy Fitzhardinge wrote:
> Muli Ben-Yehuda wrote:
> >> +#define DMA_64BIT_MASK	DMA_BIT_MASK(64)
> >>     
> >
> > This one does not do what you mean. You need an explicit mask or a
> > ~0ULL here.
> 
> Yeah, I was just about to comment on it.  Its possible the compiler
> might decide to shift by x%64 = 0.
> 
>     J
ups, i knew that this might be a corner/boundary case. Thanks, updated patches
follow...
-- 
Regards/Gruﬂ,
    Boris.
