Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYA3FiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYA3FiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 00:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYA3FiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 00:38:08 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:33691 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753756AbYA3FiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 00:38:06 -0500
Message-ID: <47A00D43.60602@acm.org>
Date: Tue, 29 Jan 2008 22:38:11 -0700
From: Zan Lynx <zlynx@acm.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Jon Masters <jonathan@jonmasters.org>
CC: Pavel Roskin <proski@gnu.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
Subject: Re: ndiswrapper and GPL-only symbols redux
References: <1201641765.18773.35.camel@dv> <1201652420.2271.91.camel@perihelion> <1201657701.24898.14.camel@dv> <20080130050424.GA22444@dallas.jonmasters.org>
In-Reply-To: <20080130050424.GA22444@dallas.jonmasters.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080129/1JK5e0-0003Hr-CG-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters wrote:

> I wouldn't quite say that. I wasn't going to comment, but...personally,
> I actually disagree with the assertions that ndiswrapper isn't causing
> proprietary code to link against GPL functions in the kernel (how is
> an NDIS implementation any different than a shim layer provided to
> load a graphics driver?), but I wasn't trying to make that point.

Well, as long as *any* part of the kernel ever links to proprietary 
code, then GPL functions link to it in exactly the same way ndiswrapper 
enables.  It's only a matter of how many steps of separation.

A perfectly GPL USB network driver linked to GPL-only functions feeds 
data into the kernel where it swirls about and emerges from a 
proprietary network filesystem driver, for example.
