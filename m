Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbZD1KQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbZD1KQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759010AbZD1KQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:16:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55964 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758957AbZD1KQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:16:10 -0400
Message-ID: <49F6D767.9050801@redhat.com>
Date: Tue, 28 Apr 2009 13:16:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <marcelo@kvack.or>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH 0/7] KVM support for 1GB pages v2
References: <1240574327-21575-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1240574327-21575-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Hi,
>
> this is the second version of the patches implementing support for 1GB
> pages in KVM. There are too many changes to the first version to mention
> them all here. The core support was rewritten to work with mapping
> levels instead of page sizes. This was the main part of the change.
> The patches still only support KVM with nested paging enabled

What is missing to get shadow paging working with this?  I don't think 
it's particularly important (it will be pretty hard to find a GB page 
without any shadowed pages in it), but I don't like arbitrary constraints.

walk_addr() needs to change to support GB pages, did I miss it in the 
patchset?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

