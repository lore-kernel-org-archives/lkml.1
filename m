Return-Path: <linux-kernel-owner+w=401wt.eu-S1756950AbZFWMSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbZFWMSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZFWMSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:18:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45510 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbZFWMSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:18:40 -0400
Message-ID: <4A40C856.2050002@redhat.com>
Date: Tue, 23 Jun 2009 15:19:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH RFC] pass write value to in_range pointers
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622151631.GA14780@redhat.com> <4A3FA6FC.9030301@novell.com> <20090622160833.GA15228@redhat.com> <4A3FB156.3030301@novell.com> <20090622172720.GC15228@redhat.com> <4A405436.1080100@gmail.com> <20090623114438.GD17635@redhat.com> <4A40C2E7.9000705@redhat.com> <4A40C434.9090306@novell.com>
In-Reply-To: <4A40C434.9090306@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2009 03:01 PM, Gregory Haskins wrote:
> Ok, so for now I will just crank up the io_bus array, and we can address
> scale another day.  Can I just drop patch 2/3 and let the io_bus govern
> the limit?
>    

So long as we have a runtime-discoverable limit, yes.

-- 
error compiling committee.c: too many arguments to function

