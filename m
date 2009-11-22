Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbZKVUou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbZKVUou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 15:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbZKVUot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 15:44:49 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42497 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbZKVUos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 15:44:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kuUruW+nQy84yccl2LvQrrWzk9uIYQXjEc4Z7ieG0pYmv+k6t6hst3TTXlQNJrzROs
         fl1fRZS9HL2t+mwgetqml/tBSHLpjdMD5SW44vvO1Aa7iSiQhWMf6cjL2ZeTlNTYSaZH
         rOBStkBqLEiyq0n9oiHs2LjVDCxKr4MACsFD4=
Date: Sun, 22 Nov 2009 23:44:51 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, kvm <kvm@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: kvm hangs w/o nolapic
Message-ID: <20091122204451.GB5246@lenovo>
References: <1258715515.7094.51.camel@johannes.local> <20091120181815.GA8779@lenovo> <1258752341.7094.79.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258752341.7094.79.camel@johannes.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 10:25:41PM +0100, Johannes Berg wrote:
> On Fri, 2009-11-20 at 21:18 +0300, Cyrill Gorcunov wrote:
> 
> > I've just booted a latest -tip with kvm without problems.
> 
> Unfortunately, -tip is usually different enough that I it tends to not
> matter to me while I'm running a mainline kernel :)
> 
> > I've been using
> > 
> > |
> > | QEMU PC emulator version 0.9.1 (kvm-84)
> 
> QEMU PC emulator version 0.10.50 (qemu-kvm-devel-88), Copyright (c)
> 2003-2008 Fabrice Bellard
> 
> > Perhaps you could capture console with "debug apic=debug") and to gather
> > more info? And .config?
>
...

Thanks Johannes! I suspect we need help from KVM developers.
 
	-- Cyrill
