Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbZBZCWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbZBZCWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 21:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbZBZCWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 21:22:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49120 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbZBZCWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 21:22:40 -0500
Message-ID: <49A5FBF8.4000908@zytor.com>
Date: Wed, 25 Feb 2009 18:18:32 -0800
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
References: <20090225203007.582030664@goodmis.org> <20090225203427.382137706@goodmis.org> <49A5F81F.6060604@zytor.com> <alpine.DEB.2.00.0902252114090.12697@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0902252114090.12697@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> 
> Hehe, I was going to use that name for the function that supplies that 
> delimiter. But then we have the question. Should the delimiter be a single 
> character. Do we allow any delimiter? Or simply pass in a function that 
> will determine the delimiter?
> 

If you allow any delimiter we might call it strtok_from_user().  ;)

	-hpa

