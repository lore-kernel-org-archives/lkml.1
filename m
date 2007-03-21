Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbXCUSJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbXCUSJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbXCUSJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:09:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbXCUSJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:09:52 -0400
Message-ID: <460174EC.8000608@redhat.com>
Date: Wed, 21 Mar 2007 14:09:48 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dale Blount <linux-kernel@dale.us>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: null pointer dereference in cfq_dispatch_requests (2.6.21-rc2
 and 2.6.20)
References: <1172685755.5773.6.camel@dwillia2-linux.ch.intel.com> <200703011308.28266.linux@f-seidel.de> <20070301123057.GO23985@kernel.dk> <loom.20070321T135132-397@post.gmane.org>
In-Reply-To: <loom.20070321T135132-397@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dale Blount wrote:
>> I'm puzzled why this is hitting Dan, but no one else has reported
>> anything. Dan, did 2.6.19 work for you?
> 
> Actually, I believe it is happening to me too.  This is on a 4-disk raid5 with
> one failed disk on two 2-port sata_sil pci controller cards.
> 
> The BUG below is from 2.6.20.3, but I will try 2.6.21-rc4 tonight.
> The disk didn't fail until 2.6.20, so I don't know if 2.6.19 would have worked
> or not.
> 
> 

Just to be clear: you have a RAID array (what level?) with a failed disk
and it's giving you the same error that Dan gets?

