Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbYFWVyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbYFWVyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 17:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbYFWVyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 17:54:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33710 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbYFWVyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 17:54:21 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48601B5A.40400@s5r6.in-berlin.de>
Date: Mon, 23 Jun 2008 23:53:30 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080614 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: David Vrabel <david.vrabel@csr.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       AntonioLin <antonio.lin@alcormicro.com>, linux-usb@vger.kernel.org,
       "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
Subject: Re: Scatter-gather list constraints
References: <Pine.LNX.4.44L0.0806231522500.30973-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0806231522500.30973-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Mon, 23 Jun 2008, David Vrabel wrote:
>> Can the number of entries in a sg list be limited?  e.g., if the
>> hardware only had support for say, 64 entries?
> 
> Yes, there are two fields in struct request_queue for this: 
> max_phys_segments (the driver's limit) and max_hw_segments (the 
> hardware's limit).

David, also have a look at <linux/blkdev.h> from the comment "Access 
functions for manipulating queue properties" downwards for accessors to 
request queue tunables.
-- 
Stefan Richter
-=====-==--- -==- =-===
http://arcgraph.de/sr/
