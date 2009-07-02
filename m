Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbZGBLXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbZGBLXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 07:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbZGBLW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 07:22:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38589 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZGBLW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 07:22:59 -0400
Message-ID: <4A4C98DD.9010005@redhat.com>
Date: Thu, 02 Jul 2009 14:24:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86,kvm: Fix section mismatches in kvm.c
References: <b9df5fa10907012240y356427b8ta4bd07f0efc6a049@mail.gmail.com>
In-Reply-To: <b9df5fa10907012240y356427b8ta4bd07f0efc6a049@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2009 08:40 AM, Rakib Mullick wrote:
>   Impact: Fix section mismatch.
>
> The function paravirt_ops_setup() has been refering the variable
> no_timer_check, which is a __initdata. Thus generates the following
> warning. paravirt_ops_setup() function is called from kvm_guest_init()
> which is a __init function. So to fix this we mark paravirt_ops_setup
> as __init.
>    

Ingo, if you already have something queued up for 2.6.31, please tack 
this on.

-- 
error compiling committee.c: too many arguments to function

