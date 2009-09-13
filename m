Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZIMUN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZIMUN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 16:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbZIMUN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 16:13:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38068 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbZIMUN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 16:13:27 -0400
Message-ID: <4AAD5213.8060205@zytor.com>
Date: Sun, 13 Sep 2009 13:12:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 02/10] x86: Convert BUG() to use unreachable()
References: <4AA991C1.1050800@caviumnetworks.com> <1252627011-2933-2-git-send-email-ddaney@caviumnetworks.com> <4AA9A031.5000602@zytor.com> <alpine.LFD.2.01.0909101806110.3654@localhost.localdomain> <20090911060701.GA18740@elte.hu> <4AAA72F3.9090103@caviumnetworks.com>
In-Reply-To: <4AAA72F3.9090103@caviumnetworks.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2009 08:55 AM, David Daney wrote:
> 
> Perhaps, although with a pre-GCC-4.5 compiler, it would end up adding
> the endless loop code to BUG() sites for configurations where the user
> has explicitly stated their preference for the code to be as small as
> possible (by turning off CONFIG_BUG).
> 
> If that is acceptable, I will prepare another revision of the patch set.
> 

The thing is that without the loop, the compiler will generate the
fall-through case code, which may add more code than the loop removes.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

