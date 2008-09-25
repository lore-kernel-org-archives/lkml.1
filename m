Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbYIYCsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbYIYCsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbYIYCs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:48:28 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:5574 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbYIYCs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:48:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bCP9OE325aXdh86vQALIe81fWQq78MF1DHobGZljqCQXyNhMB3XBEUg0V9jsJHFaqc
         eXDCKB2Fhx/X3QOKUWRVG8Ev5UJb/nwE1a+LwMzs+JbLxc1THYyQwY/7Zu4JTIoxLyPr
         lUdrIsNf5O/LBIz4lYOC1VAX3ct1svqJ7qEbQ=
Date: Thu, 25 Sep 2008 10:48:22 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
Message-ID: <20080925024821.GH21049@yantp.cn.ibm.com>
References: <48D12490.5010003@zytor.com> <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com> <48DA6887.1060709@zytor.com> <20080925003220.GE21049@yantp.cn.ibm.com> <48DADD5D.9010703@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DADD5D.9010703@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 05:37:49PM -0700, H. Peter Anvin wrote:
>> If you can tell me what manufacture vendor string is in Virtual PC I
>> can make another similar patch using dmi_name_in_vendors().
>>
>
> Supposedly "Microsoft Corporation", "Virtual Machine".  No idea what  
> pre-MS versions of VPC return.

Thanks, so we can begin with this.

-- 
Li, Yan
