Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbYCCJmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbYCCJmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 04:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbYCCJm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 04:42:26 -0500
Received: from n2a.bullet.mail.tp2.yahoo.com ([203.188.202.96]:36610 "HELO
	n2a.bullet.mail.tp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752516AbYCCJmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 04:42:25 -0500
X-Yahoo-Newman-Id: 21786.3227.bm@omp401.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EzShUeodjqClAqnTeUAqAfVnimtRX/+S+ASSa0U9ccGyZGa+y2XpceHha/+ith2pQLwRXPza9StlWXLKtb7aCGcpDkg6C3ckvzP1GOTJXEwSRCvoAdAmlXzWt2lswIqJAr0/cF6NErpRittOIGDBNGAgBPFaptm1RhLMLKTeBzk=  ;
X-YMail-OSG: lNgXB_8VM1moYUZaERmpe0kYVRgU8rVEPgdlnAgUgeqCpuMS0RB2SYbl_VZZu6X7rPT01HMgSA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Date: Mon, 3 Mar 2008 18:35:02 +1100
User-Agent: KMail/1.9.5
Cc: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>,
       "Rick van Rein" <rick@vanrein.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <2f11576a0803020901n715fda8esbfc0172f5a15ae3c@mail.gmail.com> <200803031632.47888.nickpiggin@yahoo.com.au> <20080303161025.1E7E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080303161025.1E7E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031835.03082.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 March 2008 18:14, KOSAKI Motohiro wrote:
> > > some architecture use PG_reserved for treat bad memory.
> > > Why do you want introduce new page flag?
> > > for show_mem() improvement?
> >
> > I'd like to get rid of PG_reserved at some point. So I'd
> > rather not overload it with more meanings ;)
>
> really?
>
> as far as I know, IA64 already use PG_reserved for bad memory.
> please see arch/ia64/kernel/mcs_drv.c#mca_page_isolate.
>
> Doesn't it works on ia64 if your patch introduce?

It doesn't really need to use PG_reserved there, no. It could
use PG_bad for that instead.

