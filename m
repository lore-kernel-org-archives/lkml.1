Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbYLCQ6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbYLCQ6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYLCQ54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:57:56 -0500
Received: from usul.saidi.cx ([204.11.33.34]:32823 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751188AbYLCQ54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:57:56 -0500
Message-ID: <4936BA86.7020909@overt.org>
Date: Wed, 03 Dec 2008 08:57:42 -0800
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Pierre Ossman <drzeus@drzeus.cx>
CC: linux kernel <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx,
       Matthew Garrett <mjg59@srcf.ucam.org>, Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH] ricoh_mmc: Use suspend/resume_noirq (resend)
References: <60072.67.164.5.76.1228094920.squirrel@overt.org> <20081203012300.737b5b61.akpm@linux-foundation.org>
In-Reply-To: <20081203012300.737b5b61.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 30 Nov 2008 20:28:40 -0500 (EST) philipl@overt.org wrote:
> 
>> +static struct pm_ext_ops ricoh_mmc_pm_ext_opts = {
>> +	.suspend_noirq =	ricoh_mmc_suspend_noirq,
>> +	.resume_noirq =		ricoh_mmc_resume_noirq,
>> +};
> 
> pm_ext_ops got deleted from linux-next.

Not in Pierre's tree :-P

I've sent an updated diff against linux-next.

--phil
