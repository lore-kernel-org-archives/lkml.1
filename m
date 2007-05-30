Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbXE3XFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbXE3XFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXE3XFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:05:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:62590 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbXE3XFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:05:45 -0400
Message-ID: <465E02FC.3030201@oracle.com>
Date: Wed, 30 May 2007 16:04:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hugh@veritas.com
Subject: Re: [PATCH 1/3] hexdump: more output formatting
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>	 <Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com>	 <20070523182145.7d7f1f7e.randy.dunlap@oracle.com>	 <Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>	 <20070524073131.GA17501@elte.hu>	 <Pine.LNX.4.64.0705241418270.31613@schroedinger.engr.sgi.com>	 <20070524142908.f39f42ea.akpm@linux-foundation.org>	 <20070524145517.1f32cd94.randy.dunlap@oracle.com>	 <Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com>	 <20070530143428.2f20446a.randy.dunlap@oracle.com> <9a8748490705301536p7c4d2918u1ee4ae1b6ec268f4@mail.gmail.com>
In-Reply-To: <9a8748490705301536p7c4d2918u1ee4ae1b6ec268f4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> On 30/05/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
> 
> Some friendly nitpicking below :-)
> 
>> Add a prefix string parameter.  Callers are responsible for any
>> string length/alignment that they want to see in the output.  I.e.,
>> callers should pad strings to achieve alignment if they want that.
>>
>> Add rowsize parameter.  This is the number of raw data bytes
>> to be printed per line.  Must be 16 or 32.
>>
>> Add a group_size parameter.  This allows callers to dump values
> 
> One is called "rowsize" the other "group_size". How about consistent
> naming; either "row_size" and "group_size" or "rowsize" and
> "groupsize" ?

Done.  but please don't add that to CodingStyle.

>> as 1-byte, 2-byte, 4-byte, or 8-byte numbers.  Default is
>> 1-byte numbers.  If the total length is not an even multiple
>> of group_size, 1-byte numbers are printed.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
