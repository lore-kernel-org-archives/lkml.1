Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbYKJF7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbYKJF7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 00:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYKJF7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 00:59:23 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:35374 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYKJF7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 00:59:22 -0500
Date: Mon, 10 Nov 2008 11:28:35 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: eranian@gmail.com
Cc: linux-kernel@vger.kernel.org, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] x86 debugctl MSR access interface
Message-ID: <20081110055835.GD3139@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <7c86c4470811070644h1f65ccdfi32c78fbf173abed9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470811070644h1f65ccdfi32c78fbf173abed9@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 03:44:09PM +0100, stephane eranian wrote:
> Hello,
> 
> On Intel X86 processors, the DEBUGCTL msr contains lots of bits
> to control various unrelated features, such as LBR, BTS, PMU.
> 
> Nowadays, several subsystems need access to this MSR to set or
> clear the bits they care about. In 2.6.27, the new DS/BTS interface
> was introduced and DEBUGCTL can now be cleared and restored
> on context switches.
> 
> The KPROBE interface also uses DEBUGCTL.

Stephane,

I see no problems with the kprobes part of the patch.

Ananth
