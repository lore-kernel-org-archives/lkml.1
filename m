Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYBOVAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYBOVAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765706AbYBOU7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:59:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:42437 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbYBOU7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:59:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=F4DSvUwiFSkWQqyJCNhW6CIlXl0YdYJHYwCYijCWotOqoHoyus7KoNyR3VaOxlABuPw6p3k0+fC21jHCTQ7Lt8AWcfu6IxEGMBZ3uEdcMtNMopgFEF8gzn+dTOZPDMxcA4WgewZKaLy6rHMmtnLOHXkrPZhV5aXE6y97WE+aptA=
Message-ID: <47B5FE1E.5080804@gmail.com>
Date: Fri, 15 Feb 2008 22:03:26 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
CC: Denys Fedoryshchenko <denys@visp.net.lb>,
       Bart Van Assche <bart.vanassche@gmail.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: BUG/ spinlock lockup, 2.6.24
References: <20080215150044.M24489@visp.net.lb> <e2e108260802150724k4e5e6089mcb603b524157a9bc@mail.gmail.com> <20080215193854.M55147@visp.net.lb> <47B5F462.40603@gmail.com>
In-Reply-To: <47B5F462.40603@gmail.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote, On 02/15/2008 09:21 PM:

> Denys Fedoryshchenko wrote, On 02/15/2008 08:42 PM:
> ...
> 
>> I have similar crashes on completely different hardware with same job (QOS), 
>> so i think it is actually some nasty bug in networking.
> 
> Maybe you could try with some other debugging options? E.g. since lockdep
> doesn't help - turn this off. Instead try some others, like these:

...On the other hand this:

> Feb 15 15:50:17 217.151.X.X [1521315.068984] BUG: spinlock lockup on CPU#1, 
> ksoftirqd/1/7, f0551180

seems to point just at spinlock lockup, so it's more about the full report.
I wonder if this patch to prink could help here:

author	Ingo Molnar <mingo at elte.hu>
	Fri, 25 Jan 2008 20:07:58 +0000 (21:07 +0100)
printk: make printk more robust by not allowing recursion

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=32a76006683f7b28ae3cc491da37716e002f198e

Jarek P.
