Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYHRRhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYHRRhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYHRRhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:37:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42133 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYHRRhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:37:31 -0400
Message-ID: <48A9B228.3040504@zytor.com>
Date: Mon, 18 Aug 2008 10:32:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       David Fries <david@fries.net>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix i486 suspend to disk CR4 oops
References: <20080818040340.GB17528@spacedout.fries.net> <20080818064120.GA28941@elte.hu> <20080818152440.GA26134@redhat.com>
In-Reply-To: <20080818152440.GA26134@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> 
> Is this part really necessary ?
> 
> Why would a 486 be in EFI code?
> 

Necessary, almost certainly not, but (a) it doesn't hurt anything, (b) 
it's good to be consistent and (c) it might still be useful to virtualizers.

EFI is an abomination no matter how you look at it, of course.

	-hpa
