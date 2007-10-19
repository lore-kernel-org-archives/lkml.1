Return-Path: <linux-kernel-owner+w=401wt.eu-S936469AbXJSX6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936469AbXJSX6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 19:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764387AbXJSX6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 19:58:31 -0400
Received: from web50104.mail.re2.yahoo.com ([206.190.38.32]:36617 "HELO
	web50104.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762791AbXJSX6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 19:58:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=qPXGTDEE6BNxKSqlBP7B6rKKABF5Oh4jrWnwaJumS2huZgnGlbqiVLH4WyO3OlEbPLVGv/2Sn/M8X9Gu4FzDTy9EsCPdcGduEL4vTv8DO795985teB3vTJ3znCxYpjDBPP1rQhRHxkMLZTMmgLrenVu5LU0PaaQANuV3f0uU1jw=;
X-YMail-OSG: 7CmC.4sVM1kEYaYVfIdDJg4w8HyjNK2o5XCO3epMvfMWneMxM08d8VxjBldAqgJGRgCDSA--
Date: Fri, 19 Oct 2007 16:58:29 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 6/8] drivers-edac-i3000 replace macros with functions
To: Andrew Morton <akpm@linux-foundation.org>, juhlenko@akamai.com
Cc: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071019141118.91846dee.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <282333.62461.qm@web50104.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jason,

Can you provide some information on this?

doug t


--- Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 19 Oct 2007 13:18:23 -0600
> dougthompson@xmission.com wrote:
> 
> > +static inline unsigned long deap_pfn(u8 edeap, u32 deap)
> > +{
> > +	deap >>= PAGE_SHIFT;
> > +	deap |= (edeap & 1) << (32 - PAGE_SHIFT);
> > +	return deap;
> > +}
> > +
> > +static inline unsigned long deap_offset(u32 deap)
> > +{
> > +	return deap & ~(I3000_DEAP_GRAIN - 1) & ~PAGE_MASK;
> > +}
> > +
> 
> The types here look a bit confused.  Implicit conversions of
> u32s into unsigned longs.
> 


W1DUG
