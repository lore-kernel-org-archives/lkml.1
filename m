Return-Path: <linux-kernel-owner+w=401wt.eu-S933556AbZLGHxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556AbZLGHxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933543AbZLGHxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:53:33 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:24022 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933539AbZLGHxd convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Mon, 7 Dec 2009 02:53:33 -0500
Message-Id: <4B1CC28F0200007800024075@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 07 Dec 2009 07:53:35 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Andi Kleen" <andi@firstfloor.org>, <akpm@linux-foundation.org>
Cc: <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [3/3] Fix unwind annotations for 64bit kernel
References: <20091206313.812075626@firstfloor.org>
 <20091206141311.CE0A0B151F@basil.firstfloor.org>
In-Reply-To: <20091206141311.CE0A0B151F@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <andi@firstfloor.org> 06.12.09 15:13 >>>
>
>From Jan Beulich <jbeulich@novell.com>
>
>This is an older patch from Jan Beulich to fix various problems
>with the dwarf2 CFI unwind annotations in 64bit entry_64.S/head_64.S
>CFI annotations are needed for reliable backtraces with 
>gdb, systemtap and other unwinders.
>
>[AK: I keep forward porting it to to newer kernels for my own use,
>but it should be really just included. So I'm submitting it on Jan's
>behalf]

So do we, but the initial submission was rejected due to doing too many
things at once. I didn't since find time (admittedly also because not
giving it priority) to split the patch. Thanks for giving it another try!

>Cc: jbeulich@novell.com 
>Signed-off-by: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Jan Beulich <jbeulich@novell.com>

Jan

