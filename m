Return-Path: <linux-kernel-owner+w=401wt.eu-S1761094AbZDIHje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761094AbZDIHje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 03:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757531AbZDIHjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 03:39:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56373 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757222AbZDIHjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 03:39:22 -0400
Message-ID: <49DDA64F.9020000@redhat.com>
Date: Thu, 09 Apr 2009 10:39:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] disable interrupt shadow state for emulated instruction
References: <1239213452-5966-1-git-send-email-glommer@redhat.com> <49DCE9E5.8020703@zytor.com>
In-Reply-To: <49DCE9E5.8020703@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>
> How does this logic work when the instruction emulated is an STI or 
> MOV SS instruction?  In particular, when does 
> GUEST_INTERRUPTIBILITY_INFO sets set to reflect the *blocking* operation?

The processor sets it when emulating an sti or mov ss instruction.  We 
ought to set it when emulating same.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

