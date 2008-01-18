Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbYARQQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbYARQQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761599AbYARQQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:16:14 -0500
Received: from relay1.sgi.com ([192.48.171.29]:60043 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761547AbYARQQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:16:13 -0500
Message-ID: <4790D0C9.5050200@sgi.com>
Date: Fri, 18 Jan 2008 08:16:09 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: x86 refuses to build [Re: 2.6.24-rc8-mm1]
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <20080117172857.GA24121@linux.vnet.ibm.com> <20080117184406.GA561@linux.vnet.ibm.com> <20080118085913.GD19792@elte.hu>
In-Reply-To: <20080118085913.GD19792@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> 
>> grepping around and looking through the code, I notice it is because 
>> these variables just do not exist for 32 bit NUMA. I am not sure how 
>> to go about it, and will just leave it to folks who know what they are 
>> doing there :).
> 
> yes, Mike Travis has i think some patches in the works for this build 
> problem. Disabling NUMA on 32-bit is the solution meanwhile.
> 
> 	Ingo


I have the fix for this problem coming...

Thanks,
Mike
