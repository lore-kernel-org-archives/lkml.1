Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZI0Imi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZI0Imi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZI0Imi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:42:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbZI0Imh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:42:37 -0400
Message-ID: <4ABF257C.2000803@redhat.com>
Date: Sun, 27 Sep 2009 10:42:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 1/1] KVM: fix lock imbalance
References: <1253864018-7547-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1253864018-7547-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2009 10:33 AM, Jiri Slaby wrote:
> Stanse found 2 lock imbalances in kvm_request_irq_source_id and
> kvm_free_irq_source_id. They omit to unlock kvm->irq_lock on fail paths.
>
> Fix that by adding unlock labels at the end of the functions and jump
> there from the fail paths.
>    

Applied, thanks.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

