Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbZANCz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbZANCz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZANCzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:55:19 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55239 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762AbZANCzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:55:17 -0500
Subject: Re: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
From: David Moore <dcm@MIT.EDU>
Reply-To: dcm@acm.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>, krh@redhat.com,
       stefanr@s5r6.in-berlin.de, Nadia.Derbey@bull.net,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       paulmck@us.ibm.com
In-Reply-To: <20090113144802.39dc4c23.akpm@linux-foundation.org>
References: <1231571060.3538.18.camel@localhost.localdomain>
	 <49686465.70501@s5r6.in-berlin.de>
	 <20090110011557.9d94e111.akpm@linux-foundation.org>
	 <496872E0.9030007@s5r6.in-berlin.de>
	 <1231773620.6365.21.camel@gaara.bos.redhat.com>
	 <496B9FC7.3090108@colorfullife.com>
	 <1231792712.6365.31.camel@gaara.bos.redhat.com>
	 <496BAD1C.5060201@colorfullife.com>
	 <20090113144802.39dc4c23.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 18:51:37 -0800
Message-Id: <1231901497.9714.105.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 14:48 -0800, Andrew Morton wrote:
> None of this got us much closer to fixing the bug ;)
> 
> What do we think of just removing the constructor and using
> kmem_cache_zalloc()?
> 

Yes, I agree that using kmem_cache_zalloc would be a good solution.

-David

