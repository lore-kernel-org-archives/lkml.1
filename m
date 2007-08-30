Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbXH3Ih0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbXH3Ih0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 04:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbXH3IhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 04:37:17 -0400
Received: from mx0.karneval.cz ([81.27.192.123]:5039 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755528AbXH3IhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 04:37:16 -0400
Message-ID: <46D681B4.90401@stud.feec.vutbr.cz>
Date: Thu, 30 Aug 2007 10:37:08 +0200
From: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Vitaly Mayatskikh <vmayatsk@redhat.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2.6.21] Return available first timeslice to the creator,
 not parent
References: <m3fy21qx4p.fsf@dhcp-lab-143.englab.brq.redhat.com>
In-Reply-To: <m3fy21qx4p.fsf@dhcp-lab-143.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Mayatskikh skrev:
> Short-living process returns its timeslice to the parent, this
> affects process that creates a lot of such short-living threads,
> because its not a parent for new threads.

I don't see the point of sending patches for old Linux versions such as 
2.6.21, unless it's something applicable to the -stable tree.
Do recent kernels with CFS have the same problem?

> Patch fixes this issue and
> doesn't break kabi as does the patch from reporter:
> http://lkml.org/lkml/2007/4/7/21

There's no kabi.

Michal

