Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262Ab0AUDGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab0AUDGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 22:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668Ab0AUDGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 22:06:16 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:34237 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab0AUDGG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 22:06:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xn2CR8c5MaFSAd0mTqHM9+KlVpLpSYch8yMgmNJGpkNwfYM5GeWKGW36QsOvlXfShQ
         Tyvd6LE1nrmBEN+7CfqbQaa3DGdzAphbLm3X7uucZuo1N7c2sckXO80BhExFYN/dyhYB
         wkMzLaZQMjP8DHvEBLHrcAjwDokbmm33Rj9tc=
MIME-Version: 1.0
In-Reply-To: <20100121013205.GA29808@shareable.org>
References: <20100120174630.4071.A69D9226@jp.fujitsu.com>
	 <20100120095242.GA5672@desktop>
	 <20100121094733.3778.A69D9226@jp.fujitsu.com>
	 <20100121013205.GA29808@shareable.org>
Date: Thu, 21 Jan 2010 11:06:03 +0800
Message-ID: <979dd0561001201906j5acedd8ay42d7bc68beefbb9e@mail.gmail.com>
Subject: Re: cache alias in mmap + write
From: anfei zhou <anfei.zhou@gmail.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 9:32 AM, Jamie Lokier <jamie@shareable.org> wrote:
> KOSAKI Motohiro wrote:
>>  2. Add some commnet. almost developer only have x86 machine. so, arm
>>     specific trick need additional explicit explanation. otherwise anybody
>>     might break this code in the future.
>
> That's Documentation/cachetlb.txt.
>
> What's being discussed here is not ARM-specific, although it appears
> maintainers of different architecture (ARM and MIPS for a start) may
> have different ideas about what they are guaranteeing to userspace.
> It sounds like MIPS expects userspace to use msync() sometimes (even
> though Linux msync(MS_INVALIDATE) is quite broken), and ARM expects to
> to keep mappings coherent automatically (which is sometimes slower
> than necessary, but usually very helpful).
>
>>  3. Resend the patch. original mail isn't good patch format. please
>>  consider to reduce akpm suffer.
>
> This type of change in generic code would need review from a number of
> architecture maintainers, I'd expect.
>
So should I broadcast this mail in order to get their attentions,
linux-arch@vger.kernel.org?

Thanks!
> -- Jamie
>
