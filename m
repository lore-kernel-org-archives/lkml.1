Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYIJRpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYIJRpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 13:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYIJRpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 13:45:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:29248 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbYIJRpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 13:45:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,373,1217833200"; 
   d="scan'208";a="614868865"
Message-ID: <48C807A9.60509@intel.com>
Date: Wed, 10 Sep 2008 10:45:13 -0700
From: Chris Leech <christopher.leech@intel.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
CC: Christoph Hellwig <hch@infradead.org>,
       jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [Open-FCoE] [PATCH 1/3] 24-bit types: typedef and macros for
 accessing 3-byte arrays as integers
References: <20080905165732.16689.50256.stgit@localhost.localdomain>		<20080910140712.GA12280@infradead.org>	<1221061241.27385.14.camel@norville.austin.ibm.com> <48C7F4EC.1080709@intel.com>
In-Reply-To: <48C7F4EC.1080709@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Leech wrote:
> Dave Kleikamp wrote:
>> @@ -62,7 +60,7 @@ struct timestruc_t {
>>   */
>>  typedef struct {
>>  	unsigned len:24;
>> -	unsigned off1:8;
>> +	u8 off1;
>>  	u32 off2;
>>  } lxd_t;
> 
> Shouldn't len here be changed to a __le24?  I think this just changed
> the size of lxd_t by a byte.

Never mind, I see that it's a host order field.  And presently surprised
to see that gcc combines the 24-bit bitfield with the following u8.

Chris
