Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbYA3A0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbYA3A0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYA3A0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:26:07 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:35754 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbYA3A0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:26:06 -0500
Subject: Re: ndiswrapper and GPL-only symbols redux
From: Jon Masters <jonathan@jonmasters.org>
To: Pavel Roskin <proski@gnu.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
In-Reply-To: <1201648883.18773.95.camel@dv>
References: <1201641765.18773.35.camel@dv>
	 <24944.1201645637@turing-police.cc.vt.edu>  <1201648883.18773.95.camel@dv>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 29 Jan 2008 19:25:29 -0500
Message-Id: <1201652729.2271.95.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 18:21 -0500, Pavel Roskin wrote:

> Of course, ndiswrapper could taint itself as a module, but it would be a
> purely symbolic act, since the module would be loaded already, and the
> GPL-only symbols resolved.

I think that might be an acceptable alternative to the current explicit
matching on "ndiswrapper" in the kernel. Something should say "hey, the
kernel is tainted, and I'm the reason why", not just set a global taint.

Note: personal opinion aside, I actually wasn't trying to start a huge
copyright debate here. I just thought the taint flag logic was wrong (if
we're going to match on specific modules, we should mark them) - an
alternative would be a new type of taint flag?

Jon.


