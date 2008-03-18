Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbYCRBpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbYCRBpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 21:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYCRBpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 21:45:32 -0400
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:43251 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752380AbYCRBpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 21:45:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qm3ufyqPvVt5etiFR8Mw8IBoUur1VKktufWNrZk070OLOnySsGxwaRM2vIpWD261Z3Y4zCFceBosyOFJ+G2Fnn4DsgecqCaIBJhdhKjwvOV8Uo5qharRfOMO/KDG/tp/Na3jpphhg9Kuu1/sJfGOUp575Sis+9np/I27L1dBWAo=  ;
X-YMail-OSG: MDey7WwVM1l1c8em.rSFpHFuF6p7.XNEkoL9XwEGMKDGj18lWUEKAZRBq4SLCV7L6zEx1wh8YA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: ehci-hcd affects hda speed
Date: Mon, 17 Mar 2008 17:45:28 -0800
User-Agent: KMail/1.9.6
Cc: "Lev A. Melnikovsky" <melnikovsky@mail.ru>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <alpine.LFD.1.00.0803180317050.11560@nev.ubzr> <47DF1A7E.30809@keyaccess.nl>
In-Reply-To: <47DF1A7E.30809@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803171845.29232.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008, Rene Herman wrote:
> On 18-03-08 01:24, Lev A. Melnikovsky wrote:
> 
> > DB> On Monday 17 March 2008, Rene Herman wrote:
> > DB> > +       case PCI_VENDOR_ID_VIA:
> > DB> > +               if (pdev->device == 0x3104 && pdev->revision >= 0x60) {
> >
> > DB> Unless you have specific docs from VIA saying that this register
> > DB> isn't revision-specific (at least in the sense that all revisions
> > DB> after 0x60 define that bit in that way), this should probably be a
> > DB> switch on pdev->revision and just include the known-safe revisions.
>
> > May I suggest this should be a module parameter? Because a side effect is 
> > a USB slow-down, which may be more important for somebody...
> 
> If the 10us is a EHCI specification, I'd personally think not. But if need 
> be...

It's not exactly a specification, but it's what they use as an
example of a "reasonable" value.  I think pretty much everyone
except VIA uses it as-is.  Since 1 usec is such a broken value,
I see no reason to support anything except 10 usec.

- Dave


