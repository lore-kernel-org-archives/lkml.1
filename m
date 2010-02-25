Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab0BYGJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 01:09:57 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65429 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab0BYGJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 01:09:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=M3sIokCUTuDnUmFdNtadimyxc8Ua/E4i3GS27NZy3vy0BcYWH6ZwYcXhEdgDVe090Z
         sDvnppHZeHUSQnvEZPF/no7B2zYqaFCnOldRRAWL/0aHonDop4e7mSeOO8aKn5OiLuwB
         bC8EMivTX0DQT0QIaqR/nLBgb3g3Ym2SWnK+I=
Subject: Re: [PATCH 08/12] perf: export some syscall metadata
From: Tom Zanussi <tzanussi@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
In-Reply-To: <20100225015244.GC7491@nowhere>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
	 <1264580883-15324-9-git-send-email-tzanussi@gmail.com>
	 <20100223214445.GF5357@nowhere> <1266991243.6427.44.camel@tropicana>
	 <20100225015244.GC7491@nowhere>
Content-Type: text/plain
Date: Thu, 25 Feb 2010 00:09:53 -0600
Message-Id: <1267078193.6611.146.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-25 at 02:52 +0100, Frederic Weisbecker wrote:
> On Wed, Feb 24, 2010 at 12:00:43AM -0600, Tom Zanussi wrote:
> > You can skip the syscall metadata patches (7-11) and things will still
> > work - you'll just get syscall numbers in the output instead of the
> > nicer syscall names.
> > 
> > When the event injection stuff is ready, I can re-implement those
> > patches on top of it - it shouldn't be a big deal.
> 
> 
> Yeah, this looks more reasonable I think. The 7th patch can still
> go on though, as it deals with syscall numbers, not yet names, so
> it's fine.
> 
> Ah and I'm keeping the 12th patch too (documentation) with some
> few modifications, just to tell people syscall names are not yet
> supported.
> 
> I've tested the set and played with it. It works very well.
> 
> Actually this work is just amazing. It's so easy to generate
> a script for any perf.data, with the right things inside, easy
> to modify as the callbacks are intuitive.
> 
> I'm pushing that right away so happily...
> 

Great!  Thanks for reviewing and pushing it all.

Tom

