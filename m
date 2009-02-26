Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbZBZCGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbZBZCGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 21:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZBZCGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 21:06:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33321 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbZBZCG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 21:06:29 -0500
Message-ID: <49A5F81F.6060604@zytor.com>
Date: Wed, 25 Feb 2009 18:02:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/4] uaccess: add copy_word_from_user
References: <20090225203007.582030664@goodmis.org> <20090225203427.382137706@goodmis.org>
In-Reply-To: <20090225203427.382137706@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> This patch creates a copy_word_from_user function that can copy
> a space delimited word from user space. This puts the code in
> a new lib/uaccess.c file. This keeps the code in a single location
> and may be optimized in the future.

I have a bit of an issue with the naming... at least *I* read this as 
copying a machine word, which made me wonder why you didn't just use 
"get_user".  I would suggest copy_token_from_user or something like that.

	-hpa
