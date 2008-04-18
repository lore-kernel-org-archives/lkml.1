Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbYDRFqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbYDRFqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 01:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYDRFqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 01:46:43 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55343 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbYDRFqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 01:46:43 -0400
Message-ID: <480835B5.1090500@bull.net>
Date: Fri, 18 Apr 2008 07:46:29 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Nick Andrew <nick@nick-andrew.net>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       orenl@cs.columbia.edu
Subject: Re: [RFC][PATCH 0/4] Object creation with a specified id
References: <20080404145129.637145000@bull.net> <20080415030623.GA8171@tull.net>
In-Reply-To: <20080415030623.GA8171@tull.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Andrew wrote:
> On Fri, Apr 04, 2008 at 04:51:29PM +0200, Nadia.Derbey@bull.net wrote:
> 
>>   . echo "LONG XX" > /proc/self/next_id
>>     next object to be created will have an id set to XX
>>   . echo "LONG<n> X0 ... X<n-1>" > /proc/self/next_id
>>     next object to be created will have its ids set to XX0, ... X<n-1>
>>     This is particularly useful for processes that may have several ids if
>>     they belong to nested namespaces.
> 
> 
> How do you handle race conditions, i.e. you specify the ID for the
> next object to be created, and then some other thread goes and creates
> an object before your thread creates one?
> 
> Nick.

OK, race problem between threads is fixed. Thanks for finding the issue!

The new patch series is coming next.

Regards,
Nadia

