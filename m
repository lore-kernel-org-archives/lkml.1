Return-Path: <linux-kernel-owner+w=401wt.eu-S932324AbYCDQil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbYCDQil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765549AbYCDQcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:32:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59251 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765538AbYCDQci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:32:38 -0500
Message-ID: <47CD7962.5080500@zytor.com>
Date: Tue, 04 Mar 2008 08:31:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@suse.de>, "Huang, Ying" <ying.huang@intel.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: early_res and find_e820_area for i386?
References: <1204601883.4707.96.camel@caritas-dev.intel.com> <200803041141.28404.ak@suse.de> <20080304104853.GA19022@elte.hu>
In-Reply-To: <20080304104853.GA19022@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> i disagree, the early_res stuff is still quite unclean, and what we want 
> do do is to get rid of it, not promote it into 32-bit code ... (The 
> reason we merged the early_res stuff in 2.6.25 was because it was 
> certainly cleaner than the horrible open-coded reservations that the 
> 64-bit code did before. So now we at least have a more less visible 
> enumeration of reservations.)
>  
> The correct and clean clean solution is what hpa mentioned: to do 
> reservations in the e820 space. I think hpa has some code for that 
> already and we should merge that. Peter?
> 

I do have some code for this stuff, but it's not merge-ready... I'll try 
to hammer it into shape.

	-hpa
