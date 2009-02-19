Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbZBSAb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbZBSAb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 19:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZBSAbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 19:31:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:45641 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbZBSAbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 19:31:17 -0500
Message-ID: <499CA834.4080208@kernel.org>
Date: Thu, 19 Feb 2009 09:30:44 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCHSET x86/core/percpu] implement dynamic percpu allocator
References: <1234958676-27618-1-git-send-email-tj@kernel.org>
In-Reply-To: <1234958676-27618-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 19 Feb 2009 00:31:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>   One trick we can do is to reserve the initial chunk in non-vmalloc
>   area so that at least the static cpu ones and whatever gets
>   allocated in the first chunk is served by regular large page
>   mappings.  Given that those are most frequent visited ones, this
>   could be a nice compromise - no noticeable penalty for usual cases
>   yet allowing scalability for unusual cases.  If this is something
>   which can be agreed on, I'll pursue this.

I've given more thought to this and it actually will solve most of
issues for non-NUMA but it can't be done for NUMA.  Any better ideas?

Thanks.

-- 
tejun
