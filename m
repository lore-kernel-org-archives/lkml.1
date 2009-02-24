Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbZBXMYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbZBXMYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 07:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbZBXMYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 07:24:03 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:24248 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755715AbZBXMYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 07:24:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=g8e32ibuxqMb5DU4ndRvTGbN3CoPFPIXzfY3hHXkSPGVNiMWo071XfvR1XyqXdbjEykve7mG05ys1gGcHzurZZbgfzWOWN3H9DcfoidVVVvU2HVXyGSyifPdi9dsF6MGQX7QyQ76h5aHiifRwsQJX/TPPtVWo9dd9pxYt2r2chU=  ;
X-YMail-OSG: YvdcvhIVM1lQ.4znGFSC59eRQMl.1gE7l67sdgeaKnEHnZlUP3k9xPC9.cuzIM7HzNOc2WS6sH5InIaHgetGiNCZsknacqugGSx.BAEEkXfrlXpugloAZFGDyUHwnBfh3z2WNHlM06EcPscIjVg5KQmRz7daPrKWy7u.50ydGlF9M5IHZsRkNqOQ0r1MoA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC] vm_unmap_aliases: allow callers to inhibit TLB flush
Date: Tue, 24 Feb 2009 23:23:05 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <49416494.6040009@goop.org> <200902232013.43054.nickpiggin@yahoo.com.au> <49A2F885.8030407@goop.org>
In-Reply-To: <49A2F885.8030407@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902242323.05879.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009 06:27:01 Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > Here's a start for you. I think it gets rid of all the dead code and
> > data without introducing any actual conditional compilation...
>
> OK, I can get started with this, but it will need to be a runtime
> switch; a Xen kernel running native is just a normal kernel, and I don't
> think we want to disable lazy flushes in that case.

That's fine, just make it a constant 1 if !CONFIG_XEN? And otherwise
a variable?

