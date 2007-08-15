Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbXHOJoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbXHOJoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbXHOJn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:43:58 -0400
Received: from adsl-67-117-79-109.dsl.sntc01.pacbell.net ([67.117.79.109]:2951
	"EHLO aurum.uhlenkott.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbXHOJn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:43:57 -0400
Date: Wed, 15 Aug 2007 02:43:56 -0700
From: Jason Uhlenkott <jasonuhl@jasonuhl.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Rene Herman <rene.herman@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
Message-ID: <20070815094356.GA18253@aurum.uhlenkott.net>
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org> <20070814232107.GA4265@aurum.uhlenkott.net> <Pine.LNX.4.64.0708150928200.19270@fbirervta.pbzchgretzou.qr> <46C2BB60.6010909@gmail.com> <Pine.LNX.4.64.0708151113410.19270@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708151113410.19270@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 11:20:33 +0200, Jan Engelhardt wrote:
> 
> On Aug 15 2007 10:37, Rene Herman wrote:
> > On 08/15/2007 09:28 AM, Jan Engelhardt wrote:
> >> On Aug 14 2007 16:21, Jason Uhlenkott wrote:
> >
> >> > On Tue, Aug 14, 2007 at 15:55:48 -0700, Arjan van de Ven wrote:
> >> > > NULL is not 0 though.
> >> > It is.  Its representation isn't guaranteed to be all-bits-zero,
> >> 
> >> C guarantees that.
> >
> > C guarantees what? If you're disagreeing with Jason -- he's right.
> 
> http://coding.derkeiler.com/Archive/C_CPP/comp.lang.c/2003-11/1808.html

That's about representation of integers types.  Pointer types are
another matter.

C99 sections 6.2.5 and 6.2.6 cover this.

This is all just academic language lawyering, of course.  Any machine
on which a pointer isn't NULL after being memset to 0 has serious
quality of implementation issues.
