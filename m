Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbXLXD7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbXLXD7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 22:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXLXD7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 22:59:16 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:53777 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbXLXD7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 22:59:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lNUc/v2U2h76+SPCzymNr8LUAzHxMj5Tk2IlalyA+iOlkMLlF08GunzIH0rNX0TX46K3hCIPO5ePVbPtKPgXKtroR7wRCZKtFpe1iZ7MZdCe/zBk1gH6gn7CLrmStM5THAjU436DgNxPeRw0qh4WZ7Gb6I57mubtwyPIvZwKPGU=
Message-ID: <5a4c581d0712231959n3141f535kd8182dc93bc2509d@mail.gmail.com>
Date: Mon, 24 Dec 2007 04:59:13 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Jason L Tibbitts III" <tibbs@math.uh.edu>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <ufaabo2xrxz.fsf@epithumia.math.uh.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com>
	 <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy>
	 <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com>
	 <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de>
	 <20071222100326.GF26157@elte.hu>
	 <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org>
	 <20071222190933.GA2958@elte.hu>
	 <ufaabo2xrxz.fsf@epithumia.math.uh.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 Dec 2007 16:52:56 -0600, Jason L Tibbitts III <tibbs@math.uh.edu> wrote:
> >>>>> "IM" == Ingo Molnar <mingo@elte.hu> writes:
>
> IM> Distros will likely pick SLUB if there's no performance worries
> IM> and if it's the default. Fedora rawhide already uses SLUB.
>
> Actually, it seems to me that not only does Fedora rawhide use SLUB,
> but Fedora 8 and 7 use it as well.  They don't have /proc/slabinfo and
> they all seem to have CONFIG_SLUB=y:
>
> > grep -r CONFIG_SLUB=y kernel
> kernel/devel/config-generic:CONFIG_SLUB=y
> kernel/F-7/configs/config-generic:CONFIG_SLUB=y
> kernel/F-8/config-generic:CONFIG_SLUB=y

Also true for at least recent versions of FC6 (which my bittorrent
 machine is still on), which currently run 2.6.22-14 based kernels.
And no, I didn't notice - that box usually hits triple-digit uptime
 before I reboot; in fact, it's still running a 2.6.22-9 based kernel.

--alessandro

 "Damaged people are dangerous. They know they can survive."

   (Anna Barton/Juliette Binoche, 'Damage')
