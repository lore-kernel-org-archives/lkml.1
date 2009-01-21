Return-Path: <linux-kernel-owner+w=401wt.eu-S1764342AbZAUIwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764342AbZAUIwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764136AbZAUIu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:50:26 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:24416 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763985AbZAUIuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:50:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=uXgTZf1n/XFJmPsNAse6PUlN/LOWWJ2dIuvzYQnPRJ7jgEf17pCp40p0FI8QqI5KHw
         WnSlhlb4X5ER0czKjoiAzimoHPqqeCgSIl4nDbFUASe75mKYFJeiuj4HouwwXS1o9z3C
         0wakZ7B4mTcwM6brWHpsSJbXHSYzHfZa+yW8M=
Message-ID: <4976E1CF.9050801@gmail.com>
Date: Wed, 21 Jan 2009 17:50:23 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] x86: Merge hardirq.h
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com> <1232457345-12366-5-git-send-email-brgerst@gmail.com> <4976DA9C.7000500@kernel.org>
In-Reply-To: <4976DA9C.7000500@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Brian Gerst wrote:
>> Remove unused idle_timestamp field from 32-bit.
> 
> Dropped.  X86_32 doesn't build.  X86_64 UP doesn't build.  Please at
> least do compile testing on all four combinations before sending the
> patches.

One more thing, can you please split the patch into two such that the
merging and renaming happen as separate steps so that git can tell
that a file has been renamed instead of oh two of those disappeared
and this one popped up?  It's a bit tedious but makes log tracking
much easier.

Thanks.

-- 
tejun
