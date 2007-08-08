Return-Path: <linux-kernel-owner+w=401wt.eu-S1764138AbXHHL7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764138AbXHHL7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 07:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbXHHL71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 07:59:27 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:24584 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbXHHL7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 07:59:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Xzt7WQTsYpuu4iGMe7vdb77eyQGbv6CF2/AK168Kwb1+04mRFjDzL4Zcal95eSj42ccGGf/89xKuaORx5RjNdDTlGQMXQjlEltQwG3WZlp0LvmotCiwE086SXBHN9X928/aChwC6KBS/sGRmPRgMIEz56By+e/CYRdAW83d7WwE=
Message-ID: <1a297b360708080459g1343eb55x8aa923a56c170277@mail.gmail.com>
Date: Wed, 8 Aug 2007 15:59:25 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] msleep() with hrtimers
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Jonathan Corbet" <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Roman Zippel" <zippel@linux-m68k.org>
In-Reply-To: <20070808115219.GA13878@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15327.1186166232@lwn.net>
	 <20070807124009.9f6c2247.akpm@linux-foundation.org>
	 <p73ps1ys0jz.fsf@bingen.suse.de>
	 <1a297b360708080409tfc9dee5mb92c216919bffc1e@mail.gmail.com>
	 <20070808115219.GA13878@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Andi Kleen <andi@firstfloor.org> wrote:
> On Wed, Aug 08, 2007 at 03:09:14PM +0400, Manu Abraham wrote:
> > On 08 Aug 2007 13:55:28 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> > > Andrew Morton <akpm@linux-foundation.org> writes:
> > > >
> > > > I'd be surprised if there was significant overhead - the maximum frequency
> > > > at which msleep() can be called is 1000Hz.  We'd need an awful lot of
> > > > overhead for that to cause problems, surely?
> > >
> > > The bigger risk is probably to break drivers that rely on msleep(1)
> > > really being msleep( very long depending on HZ )
> > >
> > > But the only way to find out is to try it.
> >
> > Well, i am quite sure a lot of drivers will be broken. But well .. if
>
> If you know of specific examples you should list them so that
> they can be fixed proactively.

A bit hard to state, which all since quite some are RE'd. Well you can
hear the cries when it is broken. :)

Manu
