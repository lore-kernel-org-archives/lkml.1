Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbZERInf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbZERInf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 04:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbZERInW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 04:43:22 -0400
Received: from mx1.wp.pl ([212.77.101.5]:10837 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbZERInU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 04:43:20 -0400
Date: Mon, 18 May 2009 10:49:30 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kbuild@vger.kernel.org, LKLM <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: Kconfig: fix problem in HID menu
Message-Id: <20090518104930.b9eb9936.krzysztof.h1@wp.pl>
In-Reply-To: <4A111A85.6030508@gmail.com>
References: <20090517175617.81323cc1.krzysztof.h1@wp.pl>
	<4A111A85.6030508@gmail.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [EXNE]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 10:21:25 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 05/17/2009 05:56 PM, Krzysztof Helt wrote:
> > Following syntax does not work properly if there is an options FOO2 depending on the FOO:
> > 
> > config FOO
> > 	tristate "Foo" if EMBEDDED
> > 	depends on FUD
> > 	default !EMBEDDED
> > 
> > config FOO2
> > 	bool "Foo2"
> > 	depends on FOO
> > 
> > If the EMBEDDED is not selected the FOO option is selected
> > and it cannot be unselected.
> 
> Uhuh, but that's correct behaviour. We don't want to bother user with
> tons of drivers unless he is compiling for embedded. Or am I missing
> something?
> 

I see now. I was little surprised by this. Please ignore my patch.

Regards,
Krzysztof
