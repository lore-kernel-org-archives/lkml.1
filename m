Return-Path: <linux-kernel-owner+w=401wt.eu-S1031585AbXEAF3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031585AbXEAF3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030965AbXEAF3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:29:22 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51982 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031588AbXEAF3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:29:20 -0400
Message-ID: <4636D017.5060108@zytor.com>
Date: Mon, 30 Apr 2007 22:28:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	 <20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>	 <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>	 <m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>	 <1177902195.30071.203.camel@localhost.localdomain>	 <463572B7.90202@zytor.com>	 <1177909434.30071.216.camel@localhost.localdomain>	 <m1ejm16flv.fsf@ebiederm.dsl.xmission.com>	 <1177990722.28659.39.camel@localhost.localdomain>	 <4636B7DE.5050005@zytor.com>  <4636BB6B.9070300@zytor.com> <1177995014.28659.54.camel@localhost.localdomain>
In-Reply-To: <1177995014.28659.54.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> 
> BTW, wrt. a new "platform type" field, should it go something like this?
> 
> -0235/3	N/A	pad2		Unused
> +0235/1	2.07+	platform_type	Runtime platform (see below)
> +0236/2	N/A	pad2		Unused
> ...
> +  platform_type:
> +	For kernels which can boot on multiple platforms.  Currently
> +	0 == native (normal), 1 == lguest (paravirtualized).
> 

Well, yes, but we need to think about if there is more things that
should be added.  There *definitely* should be space for a platform data
pointer, to start out with.  I would also like to see a platform data
field, as well as a bootloader extension field (we're going to have that
problem soon enough.)

	-hpa
