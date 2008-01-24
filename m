Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbYAXHCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbYAXHCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 02:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYAXHCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 02:02:13 -0500
Received: from gw.goop.org ([64.81.55.164]:57693 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbYAXHCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 02:02:12 -0500
Message-ID: <479837F3.8090905@goop.org>
Date: Wed, 23 Jan 2008 23:02:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] x86: ignore spurious faults
References: <4797D64D.1060105@goop.org> <p73hch3afbm.fsf@bingen.suse.de>
In-Reply-To: <p73hch3afbm.fsf@bingen.suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>   
>> /*
>> + * Handle a spurious fault caused by a stale TLB entry.  This allows
>>     
>
> vmalloc_fault already has nearly the same logic. You should look
> at sharing the code.

Hm, I see what you mean, but its hard to see how to share much code 
there.  It's a case of "two lines common, one line different" repeated 4 
times or so.

    J
