Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbYGVLOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbYGVLOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYGVLNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:13:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:21887 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbYGVLNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:13:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lz+jitz4sdn3w352gNbnZ4qkurRIjfpAOD/cYgAl3321ldcc7Bn+6DVPHbrPTF2jl6
         Jrim2AhlyFeYfWmsPf8Eez/1F8KL/vrV0bC1EsZfu7uAU5NtDlg2RDAPmek2bwQ48HyC
         0Q0ljKyBvbmQzpnXdBp63yxSb8sqnyierOLFE=
Message-ID: <19f34abd0807220413sabb9f65h6ac20f98efb680bf@mail.gmail.com>
Date: Tue, 22 Jul 2008 13:13:54 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: more header fixes
Cc: linux-kernel@vger.kernel.org, "the arch/x86 maintainers" <x86@kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20080722103632.GA27029@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080716142225.GA19054@elte.hu>
	 <20080722123231.GA13172@localhost.localdomain>
	 <20080722103632.GA27029@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 12:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> I've updated my script to also fix any rogue uses of header-guard
>> names in auxiliary files. I'm attaching the resulting patch.
>>
>> It doesn't really _fix_ the hideous hack, it merely unbreaks it.
>>
>> Patch #2 also fixes some left-over headers. They both apply on top of
>> tip/x86/header-guards.
>
> looks good - do you have a branch i could pull into
> tip/x86/header-guards?

I've pushed it to the 'for-tip' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/vegard/linux-2.6-headers.git

(Note that since you rebased the same branch last time, I just applied
my patches on top of _your_ branch and pushed that to above location.)

Though I still believe it should be squashed for bisectability.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
