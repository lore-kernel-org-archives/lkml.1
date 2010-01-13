Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956Ab0AMWh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab0AMWh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 17:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682Ab0AMWh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 17:37:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55393 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab0AMWh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 17:37:26 -0500
Message-ID: <4B4E4AE3.1030608@zytor.com>
Date: Wed, 13 Jan 2010 14:36:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 5/5] x86: use dmi check to treat disabled cpus as
 hotplug cpus.
References: <1263338274-6485-1-git-send-email-yinghai@kernel.org>	 <1263338274-6485-5-git-send-email-yinghai@kernel.org>	 <1263340563.2854.1011.camel@sbs-t61.sc.intel.com>	 <4B4D0E39.10200@kernel.org> <87tyupfzk8.fsf@basil.nowhere.org>	 <4B4E427D.9090207@zytor.com> <20100113222348.GE24818@basil.fritz.box>	 <4B4E48BB.5030902@zytor.com> <1263421753.2865.103.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1263421753.2865.103.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2010 02:29 PM, Suresh Siddha wrote:
>>
>> Well, that *is* working around broken code, in this case the broken code
>> is the percpu allocation strategy.
> 
> Andi, Recently percpu folks changed the per-cpu static first chunk to
> PMD SIZE right. I think that is what causing all this issue.
> 

Please don't tell me we're allocating 2 MB per CPU and throwing away
most of it...
	
	-hpa

