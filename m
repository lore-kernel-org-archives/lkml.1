Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbYGGLbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbYGGLbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 07:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYGGLbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 07:31:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:42964 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbYGGLbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 07:31:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BoPw28mTpoSCdQ6y0lC8OnERCDatD+39DexDsRQpPNKw2QAkv2e7XjeSwy2bu6hEIM
         E9XsH0zNwjuZedfgOjqZKkNQdvdH0r6hD1UMROkJb8uwS8fKmHekNA7rVsc+NjkOc0uy
         JxnszTM8CsNnWq5tRmXsswqG4A2YZ8syzR4r8=
Message-ID: <9871ee5f0807070431x167b3af3w8710b4df5b714e8d@mail.gmail.com>
Date: Mon, 7 Jul 2008 07:31:01 -0400
From: "Timothy Normand Miller" <theosib@gmail.com>
To: "Timothy Normand Miller" <theosib@gmail.com>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: HELP: Getting unexpected fakeraid behavior. Fix?
In-Reply-To: <20080707095747.GC1631@nineveh.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9871ee5f0807061307ncc55104y477c57be3e91b75f@mail.gmail.com>
	 <20080706131937.13065312@infradead.org>
	 <9871ee5f0807061424o535c6d7eg3071da6e31e0b58e@mail.gmail.com>
	 <9871ee5f0807061822l2871765bhd92aa177c0d5d55b@mail.gmail.com>
	 <9871ee5f0807061826r101a1aboe266a3432af650a2@mail.gmail.com>
	 <20080707095747.GC1631@nineveh.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2008 at 5:57 AM, Joseph Fannin <jfannin@gmail.com> wrote:

> I don't think dmraid and mdraid *are* functionally the same.  dmraid
> was written as more or less a compatibilty hack, so people using
> fakeRAID with its Windows-only software drivers could still
> dual-boot.  That could have changed somewhat while I wasn't looking,
> but it doesn't sound like it has changed much.

It looks like I've been bitten by misinformation on the web.

> mdraid is still the only "real" Linux softRAID
> implementation... though LVM also does some very RAID-like things.

I''m not sure how much you would save, but it might be more compact to
combine them.  Complexity/size tradeoff, I guess.

> Anyway, the consensus for a long time seems to be that, unless you
> need to dual-boot with a Windows system using fakeRAID drivers, you
> should just put the drive controller in AHCI mode and use mdraid.

That may be so on LKML, but others don't seem to be so well-informed.


-- 
Timothy Normand Miller
http://www.cse.ohio-state.edu/~millerti
Open Graphics Project
