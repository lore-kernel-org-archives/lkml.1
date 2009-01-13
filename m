Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbZAMKs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbZAMKs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZAMKsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:48:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:33970 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbZAMKst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:48:49 -0500
Message-ID: <496C717F.70204@kernel.org>
Date: Tue, 13 Jan 2009 19:48:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
Subject: Re: [PATCHSET linux-2.6-x86:tip] x86: make percpu offsets zero-based
 on SMP
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
In-Reply-To: <1231843097-18003-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 10:48:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Each step was tested with gcc-4.1.3, 4.2.3 and 4.3.1 on x86_64, 4.3.1
> on i386 for both SMP and UP configurations.  The final state is
> currently being tested using 4.2.3 on both x86_64 and 32.

Aieee.. two sentences mixed up in my head.  Correction:

Each step was tested with gcc-4.3.1 for both x86_64 and 32.  The final
step for x86_64 has been tested with gcc-4.1.3, 4.2.3 and 4.3.1.
Currently, I'm burn-testing both x86_64 and 32 using gcc-4.2.3 with
all patches applied.

Thanks.

-- 
tejun
