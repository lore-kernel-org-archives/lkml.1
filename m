Return-Path: <linux-kernel-owner+w=401wt.eu-S1761085AbZDQSqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761085AbZDQSqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbZDQSqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:46:01 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:59850 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507AbZDQSqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:46:00 -0400
Message-ID: <49E8CE66.8050709@s5r6.in-berlin.de>
Date: Fri, 17 Apr 2009 20:45:58 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: How to completely disable async fastboot?
References: <49E679D0.7050600@garzik.org> <20090415183137.4d19a7c8@infradead.org>
In-Reply-To: <20090415183137.4d19a7c8@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/2009 3:31 AM, Arjan van de Ven wrote:
> On Wed, 15 Apr 2009 20:20:32 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
>> > commit 9710794383ee5008d67f1a6613a4717bf6de47bc
...
>> not only changes a default, it completely removes the ability to turn 
>> off async AFAICS.
> 
> this is on the request of Andrew and others who want to be able to use
> these API's (soon) in an "forced offload" scenario. 

Indeed, because the async API is a threadpool API.
However, 2.6.30-rc1 also gained David Howell's <linux/slow-work.h>, and
I for one am still wondering which one of these I'm going to use...
-- 
Stefan Richter
-=====-==--= -=-- =---=
http://arcgraph.de/sr/
