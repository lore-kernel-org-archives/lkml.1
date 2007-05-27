Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbXE0CuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbXE0CuW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 22:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbXE0CuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 22:50:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:31731 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbXE0CuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 22:50:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=NNNskRBEfSyFRH1CwOAX3p3esGZ64Zp/nygQf7w+uLByou9oY7H9WUhO30eq2NrptKU1fnuwMmc4nR08kcWWOGhda7IBEMpdMXXZI08mltnhrB/VTNAygrgZ9BElSH2JOtfMpZE8viZuIA7H4/KQ59YAMxFxS89J+npMLHbH3Bg=
Message-ID: <4658F1D6.3070706@gmail.com>
Date: Sun, 27 May 2007 10:49:58 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v14
References: <20070523120616.GA23407@elte.hu>
In-Reply-To: <20070523120616.GA23407@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i'm pleased to announce release -v14 of the CFS scheduler patchset.
>
> The CFS patch against v2.6.22-rc2, v2.6.21.1 or v2.6.20.10 can be 
> downloaded from the usual place:
>    
>       http://people.redhat.com/mingo/cfs-scheduler/
>   
I tried this on 2.6.21.1, Good work!

I have a doubt when read this patch: in update_stats_enqueue(), It seem 
that these statements in two brances of "if (p->load_weight > 
NICE_0_LOAD)" are same,
is it on purpose?

Good luck

- Li Yu

