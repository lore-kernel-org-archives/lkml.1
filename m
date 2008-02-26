Return-Path: <linux-kernel-owner+w=401wt.eu-S1762020AbYBZJXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762020AbYBZJXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:23:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759188AbYBZJWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:22:53 -0500
Received: from n3b.bullet.mail.ac4.yahoo.com ([76.13.13.73]:38745 "HELO
	n3b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756063AbYBZJWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:22:51 -0500
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Feb 2008 04:22:51 EST
X-Yahoo-Newman-Id: 85842.2815.bm@omp410.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rFjLpzcz2KfRqnH6OAC0en2dAGKxugCnwuJrx1Lxsld0firkydvZSpJioAovJwU61ZLjc8Oyncnv8AKqKSJqvmcggPWHwuUaUzokfGwOHyZ2qh6Y3kPvaiocezgZsRw1rUAgN/v8qXiIpGX6zBPcyaI1xdDQBf5g1ZKs+McYZos=  ;
X-YMail-OSG: Z8.vT.EVM1n.4elfamAlgeqec0hkzGI5o_V13b1K1ZgNsSHAAjf7cvEj1OmyXamEzm3jcUwlTA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Gleb Natapov <glebn@voltaire.com>
Subject: Re: [ofa-general] Re: [patch 5/6] mmu_notifier: Support for drivers with revers maps (f.e. for XPmem)
Date: Tue, 26 Feb 2008 19:52:41 +1100
User-Agent: KMail/1.9.5
Cc: Robin Holt <holt@sgi.com>, steiner@sgi.com,
       Andrea Arcangeli <andrea@qumranet.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Izik Eidus <izike@qumranet.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       daniel.blueman@quadrics.com, general@lists.openfabrics.org,
       akpm@linux-foundation.org, Christoph Lameter <clameter@sgi.com>
References: <20080215064859.384203497@sgi.com> <200802261711.33213.nickpiggin@yahoo.com.au> <20080226072137.GD26611@minantech.com>
In-Reply-To: <20080226072137.GD26611@minantech.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802261952.42567.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008 18:21, Gleb Natapov wrote:
> On Tue, Feb 26, 2008 at 05:11:32PM +1100, Nick Piggin wrote:
> > > You are missing one point here.  The MPI specifications that have
> > > been out there for decades do not require the process use a library
> > > for allocating the buffer.  I realize that is a horrible shortcoming,
> > > but that is the world we live in.  Even if we could change that spec,
> >
> > Can you change the spec?
>
> Not really. It will break all existing codes.

I meant as in eg. submit changes to MPI-3


> MPI-2 provides a call for 
> memory allocation (and it's beneficial to use this call for some
> interconnects), but many (most?) applications are still written for MPI-1
> and those that are written for MPI-2 mostly uses the old habit of
> allocating memory by malloc(), or even use stack or BSS memory for
> communication buffer purposes.

OK, so MPI-2 already has some way to do that... I'm not saying that we
can now completely dismiss the idea of using notifiers for this, but it
is just a good data point to know.

Thanks,
Nick

