Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbZKAXcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbZKAXcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 18:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZKAXcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 18:32:13 -0500
Received: from www84.your-server.de ([213.133.104.84]:51047 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbZKAXcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 18:32:13 -0500
Subject: Re: [PATCH] proc: remove /proc/*/status "Stack usage:"
From: Stefani Seibold <stefani@seibold.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091101155345.GA3867@x200>
References: <20091101131518.GA18284@x200> <1257086397.31587.5.camel@wall-e>
	 <20091101155345.GA3867@x200>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 02 Nov 2009 00:32:08 +0100
Message-ID: <1257118328.7978.9.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 01.11.2009, 18:53 +0300 schrieb Alexey Dobriyan:
> On Sun, Nov 01, 2009 at 03:39:57PM +0100, Stefani Seibold wrote:
> > Am Sonntag, den 01.11.2009, 16:15 +0300 schrieb Alexey Dobriyan:
> > > We have /proc/*/pagemap to determine how much stack was consumed.
> > > Leave "threadstack" though.
> > > 
> > 
> > Stop! /proc/*/pagemap is not a real substitute for the stackm usage
> > patch. If you have problems with this patch i will have a look on it.
> 
> Why?
> 
> You grab thread stack start from /proc/*/stat, then for every page of
> stack VMA, you lookup state of page, which is exactly what you're doing
> by employing page walker.

First, as you figured out there is currently no way to get the stack
start of a thread. But i currently check this and hope to find a
solution in the next 24 hours.

Second, this patch aims to the embedded world and there is normally no
tools available when you need it, but /proc is always there. Especially
outside in the field.

Like Dr Frank. N. Furter in the "Rocky Horror Picture Show" says: remove
the cause but NOT the symptoms!

And the cause is the miss implemented KSTK_ESP in a x86_64. I also
checked all other architekture depended KSTK_ESP definitions and this
definitions looks okay for me. 

Stand by....


