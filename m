Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbZGAIJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbZGAIJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZGAIJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:09:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53061 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbZGAIJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:09:12 -0400
Message-ID: <4A4B1A13.3060809@redhat.com>
Date: Wed, 01 Jul 2009 11:10:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCHv5 0/6] kvm: locking and API rework for iosignalfd
References: <20090629192358.GA27464@redhat.com>
In-Reply-To: <20090629192358.GA27464@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2009 10:23 PM, Michael S. Tsirkin wrote:
> This series switches kvm_io_device to slots_lock from kvm->lock mutex,
> and uses that to rework io bus API. This takes less locks on data path,
> and uses less lines of code. These changes will also be useful to serve
> as basis for Greg's iosignalfd work.
>    

Applied all, thanks.

-- 
error compiling committee.c: too many arguments to function

