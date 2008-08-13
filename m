Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYHMPMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYHMPMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 11:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYHMPME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 11:12:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYHMPMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 11:12:02 -0400
Message-ID: <48A2F9AB.8000608@redhat.com>
Date: Wed, 13 Aug 2008 11:11:39 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Bruce Duncan <bwduncan@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] ftrace for v2.6.27
References: <20080714142226.GA11412@elte.hu> <200808130248.58216.bwduncan@gmail.com>
In-Reply-To: <200808130248.58216.bwduncan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruce Duncan wrote:
> Hi Ingo, Steven, everyone,
>
> [ Please CC me in replies ]
>
> I have just tracked down a regression in 2.6.27-rc2 wrt 2.6.26. Commit 
> 77a2b37d227483fe52aead242652aee406c25bf0 (ftrace: startup tester on dynamic 
> tracing.) causes my laptop to fail to resume from S3 (it simply reboots about 
> a second after the resume starts and the display never shows anything).
>
> The patch doesn't revert with patch -R (I don't know if there's a cleverer way 
> to ask git to revert it), but the problem goes away if I turn off 
> CONFIG_DYNAMIC_FTRACE.
>
> The commit and bisect log are attached. Please can you help me to debug this?
>
>
>   

I found that I have a box that displays this bug. Without FTRACE it 
suspends and resumes fine. With FTRACE enabled, it does not.

I'll be actively debugging it now. (unfortunately, as with all new 
laptops, I don't have a serial for it).

-- Steve


