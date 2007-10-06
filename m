Return-Path: <linux-kernel-owner+w=401wt.eu-S1763941AbXJFIE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763941AbXJFIE5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 04:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759181AbXJFIEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 04:04:33 -0400
Received: from smtp112.plus.mail.mud.yahoo.com ([68.142.206.245]:25751 "HELO
	smtp112.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758361AbXJFIEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 04:04:30 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Oct 2007 04:04:30 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=oGxXbCo9X0YxPfTUamrwY3MnxudW7zCbjGLTdsKYHr7v2DTQIMSZnBP1ou6upDPbyxzqQEQTBIffZOl7BouqLd4+LyMYogzy/k5Tnmsa+hRZRXm8H9EdSHatHPEYEGD2axQR2OY4S+eH9ZOegfCs8A1BjE3p6/+aV2Jkkz5iB5Q=  ;
X-YMail-OSG: omeNE9UVM1nSbK1mhlgf46cBcSUqoKBqg6vvfnA1OUOYAoD.zZWkkJi_qcRCXXHQfIHxSLB3qg--
Date: Sat, 6 Oct 2007 09:54:15 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       muli@il.ibm.com, satyam@infradead.org, amitkale@netxen.com,
       achim_leubner@adaptec.com
Subject: Re: [PATCH 1/1] unify DMA_..BIT_MASK definitions: v3.1
Message-ID: <20071006075415.GA8930@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070918194647.GA23800@gollum.tnic> <20071005124705.6584e2f9.akpm@linux-foundation.org> <4706A20A.5060603@goop.org> <20071005140050.655b7727.akpm@linux-foundation.org> <Pine.LNX.4.64.0710051701530.12079@localhost.localdomain> <4706AB5D.4060602@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4706AB5D.4060602@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 02:23:41PM -0700, Jeremy Fitzhardinge wrote:
> Robert P. J. Day wrote:
> > or you could take advantage of the macros in kernel.h and write that
> > as:
> >
> > +#define DMA_BIT_MASK(n)      (((n) == 64) ? ULLONG_MAX : ((1ULL<<(n))-1))
> >   
> 
> But that's a more indirect way of expressing "I want all 1's".
... and ULLONG_MAX _is_ (~0ULL).

-- 
Regards/Gruﬂ,
    Boris.
