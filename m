Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbZFWJxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbZFWJxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZFWJxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:53:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38963 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756734AbZFWJxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:53:18 -0400
Message-ID: <4A40A646.4010403@redhat.com>
Date: Tue, 23 Jun 2009 12:54:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH RFC] pass write value to in_range pointers
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622151631.GA14780@redhat.com> <4A3FA6FC.9030301@novell.com> <20090622160833.GA15228@redhat.com> <4A3FB156.3030301@novell.com>
In-Reply-To: <4A3FB156.3030301@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2009 07:29 PM, Gregory Haskins wrote:
>> We actually already have aliasing: is_write flag is used for this
>> purpose.
>>      
>
> Yes, but read/write address aliasing is not the same thing is
> multi-match data aliasing.  Besides, your proposal also breaks some of
> the natural relationship models (e.g. all the aliased iosignal_items
> always belong to the same underlying device.  io_bus entries have an
> arbitrary topology).
>    

It's all one big hack, we want to get the correct function called with 
as little fuss as possible.

-- 
error compiling committee.c: too many arguments to function

