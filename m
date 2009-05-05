Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbZEENgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbZEENgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZEENgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:36:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37931 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbZEENgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:36:05 -0400
Message-ID: <4A0040C0.1080102@redhat.com>
Date: Tue, 05 May 2009 16:36:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net>
In-Reply-To: <20090505132005.19891.78436.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> (Applies to Linus' tree, b4348f32dae3cb6eb4bc21c7ed8f76c0b11e9d6a)
>
> Please see patch 1/3 for a description.  This has been tested with a KVM
> guest on x86_64 and appears to work properly.  Comments, please.
>   

What about the hypercalls in include/asm/kvm_para.h?

In general, hypercalls cannot be generic since each hypervisor 
implements its own ABI.  The abstraction needs to be at a higher level 
(pv_ops is such a level).


-- 
error compiling committee.c: too many arguments to function

