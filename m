Return-Path: <linux-kernel-owner+w=401wt.eu-S964937AbXAWNEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937AbXAWNEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 08:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964927AbXAWNEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 08:04:07 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:61183 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964999AbXAWNEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 08:04:06 -0500
Subject: Re: [PATCH 04/12] clocksource: avr32 initialize list value
From: Daniel Walker <dwalker@mvista.com>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
In-Reply-To: <1defaf580701230442p3f0d6b66ue7d67a88abf5a66a@mail.gmail.com>
References: <20070123055255.338254780@mvista.com>
	 <20070123055345.727247649@mvista.com>
	 <1defaf580701230442p3f0d6b66ue7d67a88abf5a66a@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 23 Jan 2007 05:02:49 -0800
Message-Id: <1169557370.19471.20.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-23 at 13:42 +0100, Haavard Skinnemoen wrote:
> On 1/23/07, Daniel Walker <dwalker@mvista.com> wrote:
> > Update arch/avre32/ with list initialization.
> >
> > Signed-Off-By: Daniel Walker <dwalker@mvista.com>
> 
> Looks good to me, although I suppose it wouldn't hurt to include
> <linux/list.h> as well since there seems to be an ongoing effort to
> reduce the number of files that are included implicitly through other
> headers. Might save us from some trouble later.

It shouldn't be outright implicit since it's included in clocksource.h .
That has to be included before you can create a clocksource. I could see
adding list.h if it wasn't clear which include was bringing it in.

> I've closed your support request, so you shouldn't expect a reply from
> avr32@atmel.com (I was going to reply through the support system, but
> I couldn't figure out how to prevent it from top-quoting.) Probably
> best if you send patches directly to me at hskinnemoen@atmel.com, but
> the support address is a nice fallback if I'm unable to respond for
> some reason.

I got that address from the maintainers file,

AVR32 ARCHITECTURE
P:      Atmel AVR32 Support Team
M:      avr32@atmel.com
P:      Haavard Skinnemoen
M:      hskinnemoen@atmel.com
W:      http://www.atmel.com/products/AVR32/
W:      http://avr32linux.org/
W:      http://avrfreaks.net/
S:      Supported

I just picked the top address .. If it makes sense you might want to
consider dropping that address from the maintainers file. It seems a
little formal for submitting patches. In the future I'll send them to
you.

Daniel

