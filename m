Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbXLVMv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbXLVMv5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 07:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbXLVMvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 07:51:50 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:34232 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbXLVMvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 07:51:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iRwiNmki8O3Ux9Lg+reYzobCg9rp0rhtnn3BlyVuenKAt0VEsHBqUe4ZpwjVy2JjGAFOUTEMwGqNW2b3tsmC5Rb0iPPa/YwcQYg0KL5KstuUMRIVrk3CRU9tTBwe3IRk3bMoY/2J8eG17qPG0HRCHojPm+8EZyBidMByeRQpxoU=
Message-ID: <84144f020712220451s87a3957i1f1c64a60c6a8473@mail.gmail.com>
Date: Sat, 22 Dec 2007 14:51:47 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Christoph Lameter" <clameter@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20071222123705.GA14767@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071221120908.GA15926@elte.hu>
	 <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com>
	 <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy>
	 <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com>
	 <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de>
	 <20071222100326.GF26157@elte.hu>
	 <20071222123705.GA14767@one.firstfloor.org>
X-Google-Sender-Auth: 8608c2601e262044
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Dec 22, 2007 2:37 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Removing an interface that exposes lots of internal details when you
> rewrite the subsystem and those internal details all change seems
> like a good reason to me.

Yeah but then again removing an interface that has been around for
ever is a real PITA for users. Besides, emulating /proc/slabinfo ain't
so bad:

http://lkml.org/lkml/2007/12/22/58

                                Pekka
