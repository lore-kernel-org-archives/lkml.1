Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbZG2J6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbZG2J6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 05:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbZG2J6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 05:58:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54712 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbZG2J6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 05:58:34 -0400
Message-ID: <4A701E60.2020805@redhat.com>
Date: Wed, 29 Jul 2009 13:03:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com,
       Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH] kvm: remove superfluous NULL pointer check in kvm_inject_pit_timer_irqs()
References: <200907290046.40596.bzolnier@gmail.com>
In-Reply-To: <200907290046.40596.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2009 01:46 AM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] kvm: remove superfluous NULL pointer check in kvm_inject_pit_timer_irqs()
>
> This takes care of the following entries from Dan's list:
>
> arch/x86/kvm/i8254.c +714 kvm_inject_pit_timer_irqs(6) warning: variable derefenced in initializer 'vcpu'
> arch/x86/kvm/i8254.c +714 kvm_inject_pit_timer_irqs(6) warning: variable derefenced before check 'vcpu'
>
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

