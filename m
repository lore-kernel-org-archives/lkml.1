Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbZGLUny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbZGLUny (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 16:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZGLUnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 16:43:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52919 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbZGLUnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 16:43:46 -0400
Message-ID: <4A5A4AF2.40609@redhat.com>
Date: Sun, 12 Jul 2009 23:43:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: npiggin@suse.de, akpm@osdl.org, xen-devel@lists.xensource.com,
       tmem-devel@oss.oracle.com, kurt.hackel@oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, jeremy@goop.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       sunil.mushran@oracle.com, chris.mason@oracle.com,
       Anthony Liguori <anthony@codemonkey.ws>,
       Schwidefsky <schwidefsky@de.ibm.com>, dave.mccracken@oracle.com,
       Marcelo Tosatti <mtosatti@redhat.com>, alan@lxorguk.ukuu.org.uk,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Re: [RFC PATCH 0/4] (Take 2): transcendent memory
 ("tmem") for Linux
References: <e60ab548-f0be-4a75-a10b-1f2eb89247a7@default>
In-Reply-To: <e60ab548-f0be-4a75-a10b-1f2eb89247a7@default>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2009 11:39 PM, Dan Magenheimer wrote:
>> Right, the transient uses of tmem when applied to disk objects
>> (swap/pagecache) are very similar to disk caches.  Which is
>> why you can
>> get a very similar effect when caching your virtual disks;
>> this can be
>> done without any guest modification.
>>      
>
> Write-through backing and virtual disk cacheing offer a
> similar effect, but it is far from the same.
>    

Can you explain how it differs for the swap case?  Maybe I don't 
understand how tmem preswap works.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

