Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbYJGLPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbYJGLPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbYJGLP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:15:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55215 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753998AbYJGLP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:15:27 -0400
Date: Tue, 7 Oct 2008 12:15:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][SERIAL] Drop probe_baud() and default to "9600n8"
Message-ID: <20081007121519.545fd5c7@lxorguk.ukuu.org.uk>
In-Reply-To: <1223377586.5129.43.camel@test.thuisdomein>
References: <1223377586.5129.43.camel@test.thuisdomein>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Oct 2008 13:06:26 +0200
Paul Bolle <pebolle@tiscali.nl> wrote:

> The early console kernel parameters (i.e. "console=uart[...]" and
> "earlycon=uart[...]" allow to omit the baud/parity/bits option. If that
> option is not provided probe_baud() is used to determine the baud rate
> to be used by that early console.

That depends a lot on the system.

> I noticed that probe_baud() produced useless and/or unpredictable
> results on the few machines I tested the early console parameters (e.g.
> 1355 or 1200 and 115200 alternating). My guess is that this is because

Depends on what the firmware has done. When the firmware has set the port
up as is common in embedded then it is a very useful option to continue
with the rates currently in use.

> probe_baud() and simply use "9600n8" as (safe) defaults for
> baud/parity/bits.

I don't plan to apply this change. If you can figure out a reliable way
to decide a port is uninitialised and default to 9600 in that case then
that would be interesting.

Alan
