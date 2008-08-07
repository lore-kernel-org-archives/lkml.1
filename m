Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbYHGAtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbYHGAtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 20:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYHGAtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 20:49:17 -0400
Received: from smtp102.prem.mail.sp1.yahoo.com ([98.136.44.57]:28049 "HELO
	smtp102.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752062AbYHGAtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 20:49:17 -0400
X-YMail-OSG: 5LkKKzQVM1mo4h0oyUcQQ8EE32p6MLH3Rgwwt260V6grnqR7A10gkklut17BZUWO0U69ClmdoncmTML4QXGB0ZOxZ.pcepS_L14iAsq9rPCm0Zyjjs5IkOfPJ7eMsBt5gXw-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <489A4686.4080700@schaufler-ca.com>
Date: Wed, 06 Aug 2008 17:49:10 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Paul Moore <paul.moore@hp.com>
CC: Cliffe <cliffe@ii.net>, Eric Paris <eparis@redhat.com>,
       malware-list@lists.printk.net, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access scanning
References: <1217883616.27684.19.camel@localhost.localdomain> <200808051656.28231.paul.moore@hp.com> <489913CF.1010708@schaufler-ca.com> <200808061018.06110.paul.moore@hp.com>
In-Reply-To: <200808061018.06110.paul.moore@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Moore wrote:
> With multiple security markings on an entity then you have to decide if 
> you want to consider every marking at each LSM instance, or a subset.  
> The complexity in this case does go up dramatically, but I think the 
> key point for our discussion is that it doesn't matter if the entity is 
> a file or a packet.
>
>   

Perhaps you're right. I'm thinking in terms of the notion that each
LSM can have an independent file system attribute, but if they all
want to use IP options we're talking about a very limited resource.
No real biggie, I mostly wanted to point out that there's more to
stacking than fetching multiple xattrs.

