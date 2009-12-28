Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbZL1KBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbZL1KBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:01:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZL1KBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:01:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:47688 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbZL1KAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:00:55 -0500
Message-ID: <4B388246.3040100@kernel.org>
Date: Mon, 28 Dec 2009 19:02:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: fengxiangjun <fengxiangjun@neusoft.com>
CC: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.32.2 SATA link detect failed, 2.6.32.1 works fine
References: <alpine.LNX.2.00.0912211855460.1689@darkstar.example.net> <4B30134C.1050609@gmail.com> <alpine.LNX.2.00.0912220859060.1686@darkstar.example.net> <51f3faa70912211708j200ab584wa835ffe50981415e@mail.gmail.com> <alpine.LNX.2.00.0912220955341.1696@darkstar.example.net> <4B31DB17.4050509@kernel.org> <alpine.LNX.2.00.0912231719440.1694@darkstar.example.net> <4B331957.7030906@kernel.org> <alpine.LNX.2.00.0912241535340.1682@darkstar.example.net> <4B331D93.2010000@kernel.org> <alpine.LNX.2.00.0912241557170.1682@darkstar.example.net> <alpine.LNX.2.00.0912242010350.1691@darkstar.example.net> <4B336153.8090206@kernel.org> <alpine.LNX.2.00.0912250931510.1680@darkstar.example.net> <4B34C097.1000206@kernel.org> <alpine.LNX.2.00.0912260919490.1729@darkstar.example.net>
In-Reply-To: <alpine.LNX.2.00.0912260919490.1729@darkstar.example.net>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/26/2009 10:25 AM, fengxiangjun wrote:
>> Can you please try this one?  Retry logic was wrong in the original
>> patch.  With this patch, you should see one "link resume succeeded
>> after %d retries" message when the original kernel would have failed
>> probe.  Can you please test this patch and post boot log with such
>> message?
> 
> Just reboot 3 times, and test STR, every thing works fine.
> And the 3 reboots have the same message:
> 
> ata1.00: link resume succeeded after 1 retries

Cool, does it ever boot without the message?

-- 
tejun
