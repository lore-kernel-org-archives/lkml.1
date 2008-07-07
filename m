Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbYGGOqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbYGGOqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 10:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbYGGOp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 10:45:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753620AbYGGOp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:45:57 -0400
Message-ID: <48722C05.6010808@linux-foundation.org>
Date: Mon, 07 Jul 2008 09:45:25 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: steiner@sgi.com, akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: Re: [patch 12/13] GRU Driver V3 -  export is_uv_system(),	zap_page_range()
 & follow_page()
References: <20080703213348.489120321@attica.americas.sgi.com> <20080703213633.890647632@attica.americas.sgi.com> <20080704073926.GA1449@infradead.org>
In-Reply-To: <20080704073926.GA1449@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Jul 03, 2008 at 04:34:00PM -0500, steiner@sgi.com wrote:
>> +EXPORT_SYMBOL_GPL(zap_page_range);
>>  
>>  /*
>>   * Do a quick page-table lookup for a single page.
>> @@ -1089,6 +1090,7 @@ no_page_table:
>>  	}
>>  	return page;
>>  }
>> +EXPORT_SYMBOL_GPL(follow_page);
> 
> NACK.
> 
> These should never be called by a driver and suggest you need to rething
> your VM integration in this driver.

Well here we cannot run get_user_pages() since the context is atomic. What other choice is there?

