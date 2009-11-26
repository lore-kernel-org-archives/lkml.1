Return-Path: <linux-kernel-owner+w=401wt.eu-S1751254AbZKZSxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254AbZKZSxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 13:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbZKZSxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 13:53:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51874 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZKZSxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 13:53:44 -0500
Subject: Re: Missing recalculation of scheduler tunables in case of cpu hot
 add/remove
From: Peter Zijlstra <peterz@infradead.org>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Holger.Wolf@de.ibm.com, epasch@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <4B0ECB45.60906@linux.vnet.ibm.com>
References: <4B0EA88E.3030205@linux.vnet.ibm.com>
	 <1259252382.31676.207.camel@laptop>  <4B0EAC06.3010407@linux.vnet.ibm.com>
	 <1259252892.31676.220.camel@laptop>  <4B0EAD7B.90601@linux.vnet.ibm.com>
	 <1259253950.31676.249.camel@laptop>  <4B0ECB45.60906@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 19:53:34 +0100
Message-ID: <1259261614.31676.386.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 19:39 +0100, Christian Ehrhardt wrote:
> Looks very promising, I did not expect it would be so easy to hook up to 
> the hotplug events, but you're absolutley right the scheduler already 
> has hooks for that with rq_online/offline.
>  From looking at the patch alone I expect it will loose user updates to 
> sysfs. Might just need adding some feedback from the sysctl writer 
> functions to set the default values to setval/1+ilog2; that includes 
> renaming default to "normalized" or somethng like that. But I'll test 
> this patch in depth tomorrow morning anyway and give more detailed feedback.

Yeah, its needs better integration with the sysctl bits and such, but it
shows the general shape and form of things.



