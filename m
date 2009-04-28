Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbZD1KK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbZD1KK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbZD1KKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:10:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60324 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbZD1KKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:10:06 -0400
Message-ID: <49F6D5FC.90106@redhat.com>
Date: Tue, 28 Apr 2009 13:10:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <marcelo@kvack.or>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH 7/7] kvm x86: report 1GB page support to userspace
References: <1240574327-21575-1-git-send-email-joerg.roedel@amd.com> <1240574327-21575-8-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1240574327-21575-8-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> If userspace knows that the kernel part supports 1GB pages it can enable
> the corresponding cpuid bit so that guests actually use GB pages.
>   

Why not do everything via KVM_GET_SUPPORTED_CPUID2 and virtualized 
cpuid?  We can enable it in the kernel unconditionally.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

