Return-Path: <linux-kernel-owner+w=401wt.eu-S932745AbYBUWsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745AbYBUWsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761679AbYBUWsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:48:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54482 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757735AbYBUWsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:48:02 -0500
Message-ID: <47BDFBDE.5040102@zytor.com>
Date: Thu, 21 Feb 2008 14:31:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Joerg Roedel <joerg.roedel@amd.com>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: don't print a warning when MTRR are blank and	running
 in KVM
References: <1203605414-4958-1-git-send-email-joerg.roedel@amd.com> <20080221203748.GA9031@elte.hu>
In-Reply-To: <20080221203748.GA9031@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> I'm not sure how we could detect pure Qemu instances - perhaps it should 
> define some special MSR or something?
> 

Perhaps they should fix the Qemu BIOS to actually simulate working MSRs; 
if nothing else, they should set up the default MTRR to be cachable.

	-hpa
