Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbZKBNFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbZKBNFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 08:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbZKBNFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 08:05:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbZKBNFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 08:05:09 -0500
Message-ID: <4AEED907.5030306@redhat.com>
Date: Mon, 02 Nov 2009 15:05:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/11] Add "wait for page" hypercall.
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-9-git-send-email-gleb@redhat.com>
In-Reply-To: <1257076590-29559-9-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2009 01:56 PM, Gleb Natapov wrote:
> We want to be able to inject async pagefault into guest event if a guest
> is not executing userspace code. But in this case guest may receive
> async page fault in non-sleepable context. In this case it will be
> able to make "wait for page" hypercall vcpu will be put to sleep until
> page is swapped in and guest can continue without reschedule.
>    

What's wrong with just 'hlt' and checking in the guest?

-- 
error compiling committee.c: too many arguments to function

