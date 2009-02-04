Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbZBDFcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbZBDFcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 00:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbZBDFcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 00:32:07 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:24284 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750886AbZBDFcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 00:32:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JIOorKJoKpUEWtprC6yTqcS1abEQmLUYWbiCdLi5TnGqwZXTvcJC0ZAno/6OK+NxTiJFLsTwZog+P+NAMcxJvK3ZKa03wcZYSOF+V6LjiHZ800JLFu9YY6afH5yVjZgxPW+s0xBSKb7xgCFIxxT84oB5/W3sgjnNnUYXuhT9MLY=  ;
X-YMail-OSG: 0A0pJ3oVM1lc6xDS1biz_dfZ0isTdg8XpCWatfwxpuAKChcQF0FGb7rYcmYzBhv1QTDBr0lXNbShZ2xoxbKqxovx7VUPG9yNzBdB9MllFjvbXDtWLPz5WVIC3LisoZM.27jPSACDDtUZxeMMUcFpmUa3DeFQZXvmPOTBTXrf5if4174gv7H7XdEBnurVdQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: FW: [PATCH] powerpc/mm: Export HPAGE_SHIFT
Date: Wed, 4 Feb 2009 16:31:38 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Roland Dreier <rdreier@cisco.com>, Eli Cohen <eli@mellanox.co.il>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
References: <20090203164930.GA10101@mtls03> <1233712248.16867.131.camel@pasglop> <20090203211329.d6190a08.akpm@linux-foundation.org>
In-Reply-To: <20090203211329.d6190a08.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041631.39784.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009 16:13:29 Andrew Morton wrote:
> On Wed, 04 Feb 2009 12:50:48 +1100 Benjamin Herrenschmidt 
> > Do the generic hugetlbfs code provides such an API ? If not, we may need
> > to add one.
>
> I think it's something like
>
> 	huge_page_size(page_hstate(page))

That would work if you have a page, yes. If you want to query which hugepage
sizes are available, then you probably want for_each_hstate() (which is only
within mm/hugetlb.c at the moment, but I have no objections to exporting it
and symbols it requires).

