Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735Ab0A0VAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab0A0VAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 16:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546Ab0A0VAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 16:00:44 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:50573 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab0A0VAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 16:00:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=ZX52GDfnk2yUPzqsubyz0tlt1nLj/ZE81iw4Wew/NS+uMRs0ua1isZSKMerukb5gfL
         JVsVkjitTAZPAbUEnHtCX2D/Z1X37M7uxUxerSfoFdul7V67tFhpRR3YGfkUdMPf8m+M
         qqX9po7uBX9glAVlWnfVaYdPfV/9XLOKMK3Fw=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Chris Wilson" <chris@chris-wilson.co.uk>
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, "A Rojas" <nqn1976list@gmail.com>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Hugh Dickins" <hugh.dickins@tiscali.co.uk>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Eric Anholt" <eric@anholt.net>, stable@kernel.org
Subject: Re: [PATCH] drm/i915: Selectively enable self-reclaim
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain>
 <1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk>
 <alpine.LFD.2.00.1001270738220.24253@localhost.localdomain>
 <89k77n$ms73l9@fmsmga001.fm.intel.com>
 <alpine.LFD.2.00.1001270917120.24253@localhost.localdomain>
Date: Wed, 27 Jan 2010 22:03:18 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From: "Roman Jarosz" <kedgedev@gmail.com>
Message-ID: <op.u67l3skxasvm2a@kedge>
In-Reply-To: <alpine.LFD.2.00.1001270917120.24253@localhost.localdomain>
User-Agent: Opera Mail/10.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 18:19:50 +0100, Linus Torvalds  
<torvalds@linux-foundation.org> wrote:

>
>
> On Wed, 27 Jan 2010, Chris Wilson wrote:
>>
>> Yes, it survives a short torture test that leaks lots of bo objects from
>> X. Obviously this patch depends upon the new interface.
>
> All right. I'll apply my patch, since i'd rather have any half-way  
> complex
> logic for handling mappings in the generic mm code. And then I'll apply
> yours, because now I can look at it without wanting to dig my eyes out.
>
> Thanks,
>
> 		Linus

I will test it tomorrow in the evening.

Regards
Roman
