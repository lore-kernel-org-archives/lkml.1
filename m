Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbXGRKkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbXGRKkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXGRKjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:39:55 -0400
Received: from il.qumranet.com ([82.166.9.18]:50789 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbXGRKjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:39:54 -0400
Message-ID: <469DEDF7.6060001@qumranet.com>
Date: Wed, 18 Jul 2007 13:39:51 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       KVM devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH 1/3] KVM - Add missing kvm_run initializations
References: <20070716192446.GA16243@c2.user-mode-linux.org> <469C7A05.2070205@qumranet.com> <20070717162659.GD7965@c2.user-mode-linux.org>
In-Reply-To: <20070717162659.GD7965@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 18 Jul 2007 13:39:52 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> On Tue, Jul 17, 2007 at 11:12:53AM +0300, Avi Kivity wrote:
>   
>> I believe that emulate_instruction will set run->mmio if it returns 
>> EMULATE_DO_MMIO.
>>     
>
> Righto, forgot to check that.  How about this patch instead?
>
> Set exit_reason to KVM_EXIT_MMIO where run->mmio is initialized.
>
>   

Applied, thanks.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

