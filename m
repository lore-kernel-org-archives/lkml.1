Return-Path: <linux-kernel-owner+w=401wt.eu-S1764378AbXGZPYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764378AbXGZPYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756892AbXGZPYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:24:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56403 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbXGZPYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:24:40 -0400
Message-ID: <46A8BC94.3040808@zytor.com>
Date: Thu, 26 Jul 2007 08:24:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Etienne Lorrain <etienne_lorrain@yahoo.fr>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [GIT PULL] Bug- and documentation fixes for the x86 setup code
References: <200707181858.l6IIwA27032630@tazenda.hos.anvin.org> <20070726104246.GD10208@ucw.cz>
In-Reply-To: <20070726104246.GD10208@ucw.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> H. Peter Anvin (5):
>>       [x86 setup] MAINTAINERS: document x86 setup code git tree
>>       [x86 setup] build/tools.c: fix comment
>>       [x86 setup] Fix assembly constraints
>>       [x86 setup] VGA: Clear the Protect bit before setting the vertical height
>>       [x86 setup] Save/restore DS around invocations of INT 10h
> 
> Are there / were there known problems with running new setup code on
> AMD Geode and similar strange cpus? I tried to get wyse thin client to
> work, and it worked ok in 2.6.22, but something broke early in boot
> (doublefault?) with newer versions.
> 

Note also that with the new setup code you can put printf() in the setup
code; so sprinking the code with printfs and figuring out *where* it's
failing is probably step 1.

	-hpa
