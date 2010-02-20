Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab0BTJW5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 04:22:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39302 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab0BTJWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 04:22:55 -0500
Date: Sat, 20 Feb 2010 10:22:53 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       Bjorn Wesen <bjornw@axis.com>, Tim Bird <tim.bird@am.sony.com>,
       Tim Abbott <tabbott@ksplice.com>, Anders Kaseorg <andersk@ksplice.com>,
       Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 00/24] Rename kernel's magic sections for compatibility
	with -ffunction-sections -fdata-sections
Message-ID: <20100220092253.GC11287@basil.fritz.box>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 01:03:33AM +0100, Denys Vlasenko wrote:
> Hi Michal, Sam, folks,
> 
> Here is a new version of the -ffunction-sections -fdata-sections patch
> series based on current Linus tree.

Denys,

Not read all your patches. But I had recently the problem
that I need a generic way to check for a symbol being
inside the kernel image (text or data). There wasn't
a common symbol that worked for both XIP ARM and normal
architectures. Is this something addressed by your patchkit?

It essentially needs common symbol(s) that can be used
to check for the kernel image itself.

-Andi
