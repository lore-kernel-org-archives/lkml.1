Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbZEUXLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbZEUXLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 19:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbZEUXLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 19:11:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbZEUXLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 19:11:36 -0400
Message-ID: <4A15DF4E.6060209@zytor.com>
Date: Thu, 21 May 2009 16:10:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Chuck Ebbert <cebbert@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "Xin, Xiaohui" <xiaohui.xin@intel.com>, "Li, Xin" <xin.li@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Performance overhead of paravirt_ops on native identified
References: <4A0B62F7.5030802@goop.org> <20090521184233.3c3e97ad@dhcp-100-2-144.bos.redhat.com> <4A15DA4E.2090505@goop.org>
In-Reply-To: <4A15DA4E.2090505@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> In this specific instance of this example, yes.  But if you start 
> enabling various spinlock debug options then there'll be code following 
> the call.  It would be hard for the runtime patching machinery to know 
> when it would be safe to do the substitution.
> 

"When it is immediately followed by a ret" seems like a straightforward
rule to me?

	-hpa
