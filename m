Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbZJZSI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbZJZSI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZJZSI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:08:56 -0400
Received: from relay1.sgi.com ([192.48.179.29]:46922 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751858AbZJZSIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:08:55 -0400
Message-ID: <4AE5E5BA.6050903@sgi.com>
Date: Mon, 26 Oct 2009 11:08:58 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, David Rientjes <rientjes@google.com>,
       Yinghai Lu <yinghai@kernel.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] SGI x86_64 UV: Limit the number of number of SRAT
 messages
References: <20091023233743.439628000@alcatraz.americas.sgi.com>	<20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org>
In-Reply-To: <87pr8ay6tc.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andi Kleen wrote:
> Mike Travis <travis@sgi.com> writes:
> 
>> Limit number of SRAT messages of the form:
>> [    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
> 
> While I generally agree on the concept of limiting per CPU information
> (see other mail) I don't think removing this message by default 
> is a good idea. I regularly needed it for debugging some NUMA related
> problems and they still happen moderately often even today.
> 
> I think the right approach here, to limit output, would be to figure out
> a more compact output format, perhaps using a matrix in a table
> or simply printing multiple pair per line.
> 
> -Andi
> 

On our UV systems, this really is redundant information and adds noise
to the console printout.  If you need to examine it, dmesg will provide
it (or don't use the limit_console_output flag)?

I had thought of some reduction techniques to reduce console output, but
it didn't seem worth the complexity.  Perhaps I was wrong?

Thanks,
Mike

