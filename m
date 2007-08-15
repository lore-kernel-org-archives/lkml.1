Return-Path: <linux-kernel-owner+w=401wt.eu-S1765948AbXHOI5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765948AbXHOI5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 04:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759192AbXHOI5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 04:57:33 -0400
Received: from adsl-67-117-79-109.dsl.sntc01.pacbell.net ([67.117.79.109]:2900
	"EHLO aurum.uhlenkott.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759160AbXHOI5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 04:57:32 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2007 04:57:32 EDT
Date: Wed, 15 Aug 2007 01:52:17 -0700
From: Jason Uhlenkott <jason@uhlenkott.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
Message-ID: <20070815085217.GA14156@aurum.uhlenkott.net>
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org> <20070814232107.GA4265@aurum.uhlenkott.net> <Pine.LNX.4.64.0708150928200.19270@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708150928200.19270@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 09:28:54 +0200, Jan Engelhardt wrote:
> 
> On Aug 14 2007 16:21, Jason Uhlenkott wrote:
> >On Tue, Aug 14, 2007 at 15:55:48 -0700, Arjan van de Ven wrote:
> >> NULL is not 0 though.
> >
> >It is.  Its representation isn't guaranteed to be all-bits-zero,
> 
> C guarantees that.

Equality with the expression 0 is guaranteed.  Representation isn't.

http://www.c-faq.com/null/varieties.html
