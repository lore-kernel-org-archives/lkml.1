Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbYGHEwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbYGHEwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 00:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYGHEwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 00:52:09 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:35081 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751240AbYGHEwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 00:52:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4bd3z3HoUodFbPZ8YVEV+K3ytmU1POZkDG6P8mmdrzl2K1Aw6rGDM5nzUfIxeAm0+zs1El++EPgEDZ+Y7JQX5fuo104wTXROcNopJqvMKDqT/kZc3vtOegybrFBiCSBTM/lSTATc1mTRSv8++WEGDs2WQxCzrjw43Weilk6n/J4=  ;
X-YMail-OSG: C69LnCEVM1lQSybcJI.zex6KVLjY0i6R_ICjidfRYR8UOZnoB.tYnv6v7A3HiVhql4UxG.mms9mi3agnZYDKbW_u2AmkDmAI8ImAR4G0M9fjqV6bYbMPvQNOPgepcnUobzMKOSrrhRijVupkpDySis0F
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFC 0/4] Paravirtual spinlocks
Date: Tue, 8 Jul 2008 14:51:42 +1000
User-Agent: KMail/1.9.5
Cc: virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, Jens Axboe <axboe@kernel.dk>,
       Xen devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Friebel <thomas.friebel@amd.com>, Ingo Molnar <mingo@elte.hu>
References: <20080707190749.299430659@goop.org> <200807081029.19242.rusty@rustcorp.com.au>
In-Reply-To: <200807081029.19242.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081451.43433.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2008 10:29, Rusty Russell wrote:
> On Tuesday 08 July 2008 05:07:49 Jeremy Fitzhardinge wrote:
> > At the most recent Xen Summit, Thomas Friebel presented a paper
> > ("Preventing Guests from Spinning Around",
> > http://xen.org/files/xensummitboston08/LHP.pdf) investigating the
> > interactions between spinlocks and virtual machines.  Specifically, he
> > looked at what happens when a lock-holding VCPU gets involuntarily
> > preempted.
>
> I find it interesting that gang scheduling the guest was not suggested as
> an obvious solution.
>
> Anyway, concept looks fine; lguest's solution is more elegant of course :)

What's lguest's solution?
