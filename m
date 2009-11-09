Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZKIWhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZKIWhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 17:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbZKIWhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 17:37:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51764 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbZKIWhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 17:37:17 -0500
Message-ID: <4AF89989.2010402@zytor.com>
Date: Mon, 09 Nov 2009 14:36:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Ma, Ling" <ling.ma@intel.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com> <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com> <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com> <4AF7C66C.6000009@zytor.com> <87ws2059s9.fsf@basil.nowhere.org> <4AF84640.7010705@zytor.com> <20091109185434.GH26740@basil.fritz.box>
In-Reply-To: <20091109185434.GH26740@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 10:54 AM, Andi Kleen wrote:
>> Ling's numbers didn't seem to show a significant slowdown on Core 2 (it
>> was something like 0.95x baseline in the worst case, and most of the
>> cases were positive) so Core 2 doesn't seem to have a problem.
> 
> I ran quite a lot of micro benchmarks with various alignments and sizes
> the 'q' variant was not always a win. I haven't checked that particular
> version though.

Well, if you have concrete information about what the problem cases are,
then please provide it.  If you don't, but have a hunch where these
potential problems may lie, then please indicate what they might be.
Otherwise, there isn't any actionable information here.

	-hpa
