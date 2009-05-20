Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbZETMAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbZETMAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 08:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbZETMAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 08:00:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56429 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744AbZETMAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 08:00:36 -0400
Message-ID: <4A13F0E1.9040102@redhat.com>
Date: Wed, 20 May 2009 15:00:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mark Langsdorf <mark.langsdorf@amd.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][KVM][retry 3] Add support for Pause Filtering to AMD
 SVM
References: <200905050909.58583.mark.langsdorf@amd.com> <200905071000.14038.mark.langsdorf@amd.com> <200905081203.55484.mark.langsdorf@amd.com> <200905191356.37071.mark.langsdorf@amd.com>
In-Reply-To: <200905191356.37071.mark.langsdorf@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Langsdorf wrote:
> On a 24 core system running 4 guests each with 16 VCPUs,
> this patch improved overall performance of each guest's
> 32 job kernbench by approximately 1%.  Further performance
> improvement may be possible with a more sophisticated
> yield algorithm.
>
>   

This result is approximately what you got on your previous patch.  Did 
you measure with the new patch?  approximately 1% seems to be too low.

-- 
error compiling committee.c: too many arguments to function

