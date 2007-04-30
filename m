Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbXD3XQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbXD3XQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbXD3XQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:16:31 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34325 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbXD3XQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:16:30 -0400
Message-ID: <463678BA.5080609@zytor.com>
Date: Mon, 30 Apr 2007 16:16:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org>	<m18xc9344o.fsf@ebiederm.dsl.xmission.com> <463670D1.3000003@goop.org> <m14pmx31bw.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m14pmx31bw.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> I'm tempted to just reload the segments in setup.S, but that might
> break loadlin support or one of the other bootloaders that starts the
> kernel in 32bit mode so we need to be careful.
> 

We already load all the segments in setup.S.  I'm retaining this in my
rewrite.

Given that I'm rewriting the whole thing, if there are things you want
setup.S to do, now is the time to ask.

	-hpa
