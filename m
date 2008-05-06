Return-Path: <linux-kernel-owner+w=401wt.eu-S932767AbYEFRtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767AbYEFRtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbYEFRtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:49:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59725 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbYEFRtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:49:05 -0400
Message-ID: <482099E6.5060208@zytor.com>
Date: Tue, 06 May 2008 10:48:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: yhlu.kernel@gmail.com
CC: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fixed mtrr change WP to WB
References: <200805041823.57198.yhlu.kernel@gmail.com> <200805061038.58023.yhlu.kernel@gmail.com> <200805061041.40047.yhlu.kernel@gmail.com>
In-Reply-To: <200805061041.40047.yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> [PATCH] x86: fixed mtrr change WP to WB
> 
> so we modify mptable near below 1M
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Again:

This does not work on even the majority of all systems.

If the mptable should be modified, it should be copied to kernel memory 
and modified there.  Modifying it in-place is both unsafe and, in 
general, simply will not work.

Sorry.

NAK on this whole set.

	-hpa
