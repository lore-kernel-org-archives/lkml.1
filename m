Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbZGGG1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbZGGG1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 02:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbZGGG1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 02:27:06 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:51405 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830AbZGGG1F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 02:27:05 -0400
Message-Id: <4A5306D8020000780000918E@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 07 Jul 2009 07:27:04 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Tim Abbott" <tabbott@ksplice.com>, <tabbott@MIT.EDU>
Cc: <tony.luck@intel.com>, "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       <sam@ravnborg.org>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Paul Mackerras" <paulus@samba.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] also discard .*init sections after
	 module	initialization
References: <4A4A19C60200007800008353@vpn.id2.novell.com>
 <200907011452.26720.rusty@rustcorp.com.au>
 <4A4B2683020000780000862F@vpn.id2.novell.com>
 <alpine.DEB.1.10.0907011454050.18560@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0907011454050.18560@vinegar-pot.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Tim Abbott <tabbott@ksplice.com> 06.07.09 17:55 >>>
>On Wed, 1 Jul 2009, Jan Beulich wrote:
>> Why? .*exit sections deal with device/memory/CPU hot remove, which is
>> orthogonal to module unload.
>
>For the core kernel, the .devinit sections are currently being squashed 
>into either the .data section or the .init.data section depending on 
>whether hotplug is enabled using the vmlinux linker scripts.  Can we use 
>the same approach for modules (i.e. have a module linker script that does 
>this)?  It seems that would avoid having two duplicate mechanisms for 
>doing the same thing, one in the module loader and one in the core 
>kernel's linker scripts.

I'd have to play with this a little, as I'm not sure ld -r can actually do what
you're suggesting.

Jan

