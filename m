Return-Path: <linux-kernel-owner+w=401wt.eu-S1752241AbZIHV26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbZIHV26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 17:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZIHV25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 17:28:57 -0400
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:59173 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168AbZIHV25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 17:28:57 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-14.arcor-online.net 4C03A28ACC3
Message-ID: <4AA6CC99.6010701@arcor.de>
Date: Wed, 09 Sep 2009 00:28:57 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu> <h81v7t$p6e$1@ger.gmane.org> <20090907074039.1b6bc1ac@infradead.org> <4AA6056A.4020106@arcor.de> <20090908013800.296a5fb5@infradead.org> <4AA62E4E.4040700@arcor.de> <20090908120311.GK22901@mit.edu>
In-Reply-To: <20090908120311.GK22901@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 03:03 PM, Theodore Tso wrote:
> On Tue, Sep 08, 2009 at 01:13:34PM +0300, Nikos Chantziaras wrote:
>>> despite the untranslated content, it is clear that you have scheduler
>>> delays (either due to scheduler bugs or cpu contention) of upto 68
>>> msecs... Second in line is your binary AMD graphics driver that is
>>> chewing up 14% of your total latency...
>>
>> I've now used a correctly installed and up-to-date version of latencytop
>> and repeated the test.  Also, I got rid of AMD's binary blob and used
>> kernel DRM drivers for my graphics card to throw fglrx out of the
>> equation (which btw didn't help; the exact same problems occur).
>>
>> Here the result:
>>
>>      http://foss.math.aegean.gr/~realnc/pics/latop2.png
>
> This was with an unmodified 2.6.31-rcX kernel?

Yes (-rc9).  I also tested with 2.6.30.5 and getting the same results.


> Does Latencytop do anything useful on a BFS-patched kernel?

Nope.  BFS does not support any form of tracing yet.  latencytop runs 
but only shows a blank list.  All I can say is that a BFS patched kernel 
with the same .config fixes all visible latency issues.
