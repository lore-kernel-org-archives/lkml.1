Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbZDNOme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbZDNOme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbZDNOmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:42:24 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:42480 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752264AbZDNOmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:42:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=yJ/WWbUu/Scnp20bziBXfPm6bdVlkU3vNzKE9VA+nDuUIoYCbsv+evo94WO7Id06+xio5EZJU+CNl5BgngykFhZ0mC3Yp6Z1VRFM3UTIqUntrwIyBl7ACaMxssWKLhvQNPmWJILiWRY2VFOKHjvYgPL1vdsVCzy60NuAYCLJIko=  ;
X-YMail-OSG: Wxk_Ch0VM1njX.cpTUuOYTlGLfXNDuk0onjCCGm855EhcQeze3uwFqKIHTVLKW_4AAg.NKKyrWlhcsrQ.7UIy47Zxu1DPIK8GqXwh8fdTt2ySMKVD2_qKeGbL.ykSqSNhqDEDpjQ7etM.ZANpc96j_aSCwI7M4DiGzVrtfBez14nn4DTZ18BnvxZcq9Ji5m3YTUPUYf2WKU6gKcGPkpdGhxholAx63JjESEebEvNeUtaXFewRcR5suL2of_uhhoGKkc1cL6r2w3XXqlv
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC][PATCH v3 1/6] mm: Don't unmap gup()ed page
Date: Wed, 15 Apr 2009 00:42:14 +1000
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Jeff Moyer <jmoyer@redhat.com>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>
References: <20090414151204.C647.A69D9226@jp.fujitsu.com> <200904150026.36142.nickpiggin@yahoo.com.au> <20090414143252.GE28265@random.random>
In-Reply-To: <20090414143252.GE28265@random.random>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904150042.15653.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 April 2009 00:32:52 Andrea Arcangeli wrote:
> On Wed, Apr 15, 2009 at 12:26:34AM +1000, Nick Piggin wrote:
> > Andrea: I didn't veto that set_bit change of yours as such. I just
> 
> I know you didn't ;)
> 
> > noted there could be more atomic operations. Actually I would
> > welcome more comparison between our two approaches, but they seem
> 
> Agree about the welcome of comparison, it'd be nice to measure it the
> enterprise workloads that showed the gup_fast gain in the first place.

I think we should be able to ask IBM to run some tests, provided
they still have machines available to do so. Although I don't want
to waste their time so we need to have something that has got past
initial code review and has a chance of being merged.

If we get that far, then I can ask them to run tests definitely.
