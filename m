Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0CIP5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 10:57:17 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62093 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab0CIP5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 10:57:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=p53LkOvMjlnVkt6De4adqMsbEwkosYcE9Ry0Ji6WxAR3E/vPvbrk63FQO3tpFG/MQk
         ow2WEgILf5pu3bFCOCeHIBS5jduOA9ICTiFL1XkyBO3+floHMJmbu89FL27YPhq+Z2Vz
         MS2r7/ObJW/vrJr0RJKldFWlcBH0aTp8jPldM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.1002282111280.6474@dr-wily.mit.edu>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com> 
	<alpine.DEB.1.10.1002282111280.6474@dr-wily.mit.edu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 9 Mar 2010 10:56:51 -0500
Message-ID: <8bd0f97a1003090756u28e6f3bdpd44b8fce15f92ac1@mail.gmail.com>
Subject: Re: [PATCH 00/24] Rename kernel's magic sections for compatibility 
	with -ffunction-sections -fdata-sections
To: Tim Abbott <tabbott@ksplice.com>
Cc: Michal Marek <mmarek@suse.cz>, Denys Vlasenko <vda.linux@googlemail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       Bjorn Wesen <bjornw@axis.com>, Tim Bird <tim.bird@am.sony.com>,
       Anders Kaseorg <andersk@ksplice.com>, Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Barry Song <barry.song@analog.com>,
       Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 23:03, Tim Abbott wrote:
> On Sat, 20 Feb 2010, Denys Vlasenko wrote:
>> Here is a new version of the -ffunction-sections -fdata-sections patch
>> series based on current Linus tree.
>
> Aside from patch 17, which I would prefer that Haavard review, these
> patches look correct (and patch 17 can be safely dropped).  Please
> consider the rest of Denys' patches in this patch series
>
> Acked-by: Tim Abbott <tabbott@ksplice.com>
>
> The patches still apply fine on Linus' current master.  There are no merge
> conflicts with linux-next's current master, but we will need to do
> something to merge with
>
> "Blackfin: initial XIP support"
>
> in linux-next, which introduces a direct reference to .data.percpu.* (not
> using the normal PERCPU macros so they can put .data.percpu content inside
> the .init.data section).  That conflict looks easy to deal with by adding
> a new macro to handle this case (CCing the author and blackfin maintainer;
> it's possible that this blackfin patch is going in soon, in which case we
> can just rebase these patches on top).
>
> Michal, what are your thoughts on this patch series?  The kbuild tree
> would be a reasonable path for merging these patches.

ive posted this patch for merging via the Blackfin tree now, so
hopefully it'll be in soon
-mike
