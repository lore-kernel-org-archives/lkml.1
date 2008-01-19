Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbYASXwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbYASXwB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 18:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYASXvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 18:51:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60124 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbYASXvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 18:51:53 -0500
Message-ID: <47928CE3.9000008@zytor.com>
Date: Sat, 19 Jan 2008 15:50:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk>	<1200758937-22386-2-git-send-email-ijc@hellion.org.uk> <87prvxct42.fsf@basil.nowhere.org>
In-Reply-To: <87prvxct42.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> That will break if the kernel is > 4GB won't it? Also same for pmd.
> 

The kernel can't be > 4 GB; after all, we're running here with paging 
disabled, so inherently we're < 4 GB...

	-hpa
