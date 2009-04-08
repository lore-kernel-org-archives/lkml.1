Return-Path: <linux-kernel-owner+w=401wt.eu-S1759849AbZDHUVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759849AbZDHUVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZDHUVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:21:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54012 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbZDHUVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:21:40 -0400
Message-ID: <49DD073E.4050804@redhat.com>
Date: Wed, 08 Apr 2009 13:21:18 -0700
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gary Hade <garyhade@us.ibm.com>
CC: mingo@elte.hu, mingo@redhat.com, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: BUG from text_poke() during CPU offlining
References: <20090408201107.GA11159@us.ibm.com>
In-Reply-To: <20090408201107.GA11159@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gary,

Gary Hade wrote:
> I ran into the below BUG with 32-bit 2.6.30-rc1 while offlining
> all of the offlineable CPUs.  It happened when the last offlineable
> CPUs was being offlined.  The problem disappeared after I reverted
> the following two patches.
>  - x86: implement atomic text_poke() via fixmap
>    http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=78ff7fae04554b49d29226ed12536268c2500d1f
>  - x86: expand irq-off region in text_poke()
>    http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7cf49427042400d40bdc80b5c3399b6b5945afa8

Hmm, this bug seems that the same bug I reported recently.

http://lkml.org/lkml/2009/4/4/71

I'm working on that.

Thank you for reporting!


> 
> Gary
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

