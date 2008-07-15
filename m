Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYGOKxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYGOKxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 06:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756503AbYGOKxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 06:53:34 -0400
Received: from il.qumranet.com ([212.179.150.194]:57381 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756476AbYGOKxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 06:53:33 -0400
Message-ID: <487C818C.6060908@qumranet.com>
Date: Tue, 15 Jul 2008 13:53:00 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allow enabling/disabling NPT by reloading only the architecture
 module
References: <1216060596-6224-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1216060596-6224-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (firebolt.argo.co.il [0.0.0.0]); Tue, 15 Jul 2008 13:53:00 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> If NPT is enabled after loading both KVM modules on AMD and it should be
> disabled, both KVM modules must be reloaded. If only the architecture module is
> reloaded the behavior is undefined. With this patch it is possible to disable
> NPT only by reloading the kvm_amd module.
>
>   

Applied, thanks.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

