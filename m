Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbZKQWV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbZKQWV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbZKQWV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:21:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38264 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbZKQWVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:21:54 -0500
Message-ID: <4B0321F9.5060308@zytor.com>
Date: Tue, 17 Nov 2009 14:21:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] x86: UV SGI, Don't track GRU space in PAT
References: <20091029184723.GA562@sgi.com> <20091108120609.GW11372@elte.hu> <20091117212318.GA21137@sgi.com>
In-Reply-To: <20091117212318.GA21137@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2009 01:23 PM, Jack Steiner wrote:
> GRU space is always mapped as WB in the page table. There is
> no need to track the mappings in the PAT. This also eliminates
> the "freeing invalid memtype" messages when the GRU space is unmapped.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> ---
> Version 2 with changes suggested by Ingo (at least I think I understood what
> he wanted).

Looks good, except I think is_untracked_pat_range() probably should me a
member in the x86_platform structure -- as, probably, should
x86_platform_ipi_callback.

	-hpa
