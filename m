Return-Path: <linux-kernel-owner+w=401wt.eu-S932622AbXIMUFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbXIMUFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 16:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759268AbXIMUFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 16:05:10 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:22889 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757156AbXIMUFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 16:05:09 -0400
X-YMail-OSG: kk6uZlUVM1mVDDpWtPEeq6LGiRdxol9rGL5ssG1XSebW_wkl9I8LC.W.ktHr88BgqSCxGa3Brg--
Date: Thu, 13 Sep 2007 13:05:06 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       davej@redhat.com, Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC PATCH] Add a 'minimal tree install' target
Message-ID: <20070913200506.GA11582@puku.stupidest.org>
References: <20070912232534.GA26868@puku.stupidest.org> <20070913183359.GA27146@uranus.ravnborg.org> <20070913185753.GA9259@puku.stupidest.org> <20070913191938.GD27146@uranus.ravnborg.org> <20070913201727.GW475@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913201727.GW475@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 10:17:27PM +0200, Oleg Verych wrote:

> That particular one-line `ALTARCH := i386' of course can be matched
> simpler, because there's only *one* (as written above) whitespace and no
> make's assignment variations,

The goal is to extract the RHS from ALTARCH := ...

> Also, please take a look on man isspace(). It matches much more
> characters, than necessary for ordinary syntax whitespace.

Good point.


> Using [:blank:] (i.e. tab and space, with no options) is OK. Last
> thing: i'm not sure, what that `+' is. I stick to BRE in sed, as it
> should be, so just don't know what it does.

The \+ was misplaced :-) I typed that very quickly and didn't think to
hard.
