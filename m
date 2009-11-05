Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbZKEFRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbZKEFRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 00:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZKEFRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 00:17:49 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:58323 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbZKEFRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 00:17:49 -0500
Message-ID: <4AF25FFB.5020700@us.ibm.com>
Date: Wed, 04 Nov 2009 21:17:47 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Mike Fulton <fultonm@ca.ibm.com>, Sean Foley <Sean_Foley@ca.ibm.com>
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
References: <1256172744.4768.22.camel@localhost.localdomain> <20091021190028.623a7f6e.akpm@linux-foundation.org> <20091105112303.208A.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091105112303.208A.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

> John, I'd prefer to suggested another design.
> How about this?
> 
> 1. remove pid argument from prctl
> 2. cancel pthread_setname_np()
> 3. instead, create pthread_attr_setname_np()
> 4. pthread_create() change own thread name by pthread_attr.
> 
> 
> It avoid many racy problem automatically.

Perhaps, but it also greatly reduces the flexibility of the 
implementation by restricting name changes to create time.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
