Return-Path: <linux-kernel-owner+w=401wt.eu-S1761734AbYC0VT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761734AbYC0VT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 17:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759047AbYC0VTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 17:19:16 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:32546 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757563AbYC0VTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 17:19:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mWCStCfwZRi6xtbbn2zQleY9F4XxwqwlhXw59aWDB5GPm5RRq+XlM+Y8D+2gPB0tvW9k2GPWC99vpVY/kSg/5NFAe0PA9n3f6chhxskCTah86Ly8oe/TJfIAWmYVHXMhB796JBuFepQ2AtNgpZquL/qfRk9pe5Y7gSHkJA/amcQ=  ;
X-YMail-OSG: T4h9sZ4VM1kICmLRN_6uyhVITt7t9nc0e5_Rq0mofC99V55awH8JUa.WhWtrPgYtM3OZNt1QLoIEEIBFOyWiWdfMuXoQ6H2P.XYO8RSBSUUeXPqyAg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: some minor issues with 2.6.25-rc6-git7-default
Date: Thu, 27 Mar 2008 14:18:44 -0700
User-Agent: KMail/1.9.6
Cc: linux-mtd@lists.infradead.org, rjw@sisk.pl, devzero@web.de,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       lenb@kernel.org, greg@kroah.com, linux-ide@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
References: <212011377@web.de> <200803271222.41579.david-b@pacbell.net> <20080327134150.5f79dc0b.akpm@linux-foundation.org>
In-Reply-To: <20080327134150.5f79dc0b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803271418.44944.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 March 2008, Andrew Morton wrote:
> 
> > And there's a regression in mtd/maps/phsymap.c which should
> > be resolved before 2.6.25 ships ... on some platforms it
> > newly likes to oops on reboot.
> 
> I don't appear to have anything which touches physmap.c here.
> 
> > I don't have a URL for that patch, but ISTR it's been
> > posted both to LKML and to linux-MTD.  (That doesn't
> > include less-good versions I've seen too.)  If needed,
> > I can dig it up, but I've been thinking this should have
> > a signoff from MTD folk.
> 
> Yes, please dig it out and let's look at it.

Posted 13-March, but it wasn't quite new then:

  http://marc.info/?l=linux-kernel&m=120542496625709&w=2

I'll forward it again.

