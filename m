Return-Path: <linux-kernel-owner+w=401wt.eu-S1756955AbZANG6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbZANG6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 01:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZANG6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 01:58:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56956 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbZANG6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 01:58:14 -0500
Message-ID: <496D8CEB.5060402@zytor.com>
Date: Tue, 13 Jan 2009 22:57:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, mingo@elte.hu,
       travis@sgi.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [PATCHSET linux-2.6-x86:tip] x86: make percpu offsets zero-based
 on SMP
References: <1231843097-18003-1-git-send-email-tj@kernel.org>	 <496C717F.70204@kernel.org> <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com> <496C9FB7.9050907@kernel.org>
In-Reply-To: <496C9FB7.9050907@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> 
> I think the two changes aren't exclusive at all.  The order of things
> could be different but in the end, yeah, zero-based percpu symbols w/
> mostly empty pda is the goal.
> 
>> Once the PDA is empty, I'll base %gs at the start of the per-cpu
>> area.  I've been working out the bugs with the last patch
>> (zero-basing the percpu area) before submitting, but I probably
>> won't have the time until this weekend to polish it off.  I could
>> submit all but the last patch if you'd like.
> 
> Any chance you can rebase those patches on top of mine?  If you don't
> have time, just send them to me, I'll try to integrate them this week.
> 

A merged tree here would be absolutely wonderful.  I've kept an eye on
the discussion so far, but it looks like you guys are handling it fine.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

