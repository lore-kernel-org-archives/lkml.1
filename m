Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbYJKI3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbYJKI3m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 04:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbYJKI3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 04:29:32 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:38499 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752492AbYJKI3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 04:29:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KauxSADbKXfwYyYaRMZuZUho6z1pdhZQKqb2/egwrTRSal+zGOvWQ9BZyK9B8xyTNTFqhffCQTdgubuvqrwrGvocNMCYPlQSfXwadk6oMCR3ljjNX/KcXAcrksHiHAorSVQ7J9By7/aSWxL/FbiQUHMZGKeV9N/LmylF1oftoaw=  ;
X-YMail-OSG: od3D0K0VM1l7U_f2bAtyrOFOTiWjke9t0KNgv0KoVs4MR22yNZKmOJ0z4lMaICGfrqIP5Exfwnv21F2x7S0QC.fGjLgrwnEUkbuwqJ5X4AoKwpT9.Up7DyIfzjCrFg5.6WWwRn5c6e1O6atQsywvDJJYJX3kZyJmY1YJDUJE
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Update cacheline size on X86_GENERIC
Date: Sat, 11 Oct 2008 19:29:19 +1100
User-Agent: KMail/1.9.5
Cc: Dave Jones <davej@redhat.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <20081009171453.GA15321@redhat.com> <200810111459.53306.nickpiggin@yahoo.com.au> <20081011080812.GA9880@one.firstfloor.org>
In-Reply-To: <20081011080812.GA9880@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810111929.19891.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 October 2008 19:08, Andi Kleen wrote:
> > I guess there is a reasonable argument to not care about P4 so
>
> I don't think it is. Ignoring old systems would be a mistake
> and the wrong signal. One of Linux's forte over the competition
> was always to run reasonable on older systems too.

I think there is a reasonable argument: and that is that most
multiprocessor P4 systems in production and using a GENERIC (ie.
probably not custom but probably vendor compiled) kernel is not
likely to be upgraded to a 2.6.28+ based GENERIC kernel.

I also think there are reasonable arguments the other way, and I
personally also think it might be better to leave it 128 (even
if it is unlikely, introducing a regression is not good).


> There are millions and millions of P4s around.
> And they're not that old, they're still shipping in fact.

Still shipping in anything aside from 1s systems?


> And the point of GENERIC was to be a reasonable default on all
> systems.
>
> If you want to optimize for a specific CPU you're always free
> to compile the kernel for that. But GENERIC should be really
> GENERIC.
>
> > much in today's GENERIC kernel. If it is worth around 1% on tpc
> > on a more modern architecture, that is a pretty big motivation
> > to change it too...
>
> TPC is a extreme case, it is extremly cache bound.

Still, 1% there is a large increase.


> Besides I suspect the TPC issue could be fixed with a minimal
> tweaks without breaking other systems.

That would be nice. It would be interesting to know what is causing
the slowdown.
