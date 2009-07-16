Return-Path: <linux-kernel-owner+w=401wt.eu-S932668AbZGPQJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668AbZGPQJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932586AbZGPQJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:09:55 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44551 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581AbZGPQJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:09:54 -0400
Message-ID: <4A5F50CE.1060808@us.ibm.com>
Date: Thu, 16 Jul 2009 11:09:50 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       glommer@redhat.com
Subject: Re: [KVM PATCH] KVM: introduce "xinterface" API for external interaction
 with guests
References: <20090716150323.29318.17714.stgit@dev.haskins.net> <20090716151945.29318.10882.stgit@dev.haskins.net> <4A5F4945.3080202@us.ibm.com> <4A5F4B96.6050409@novell.com>
In-Reply-To: <4A5F4B96.6050409@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> That said, I think the assumption that was made when I was using this
> was that a proper ref for the page was acquired by the gfn_to_page() and
> dropped by the caller.  This was always used in the context of a
> hypercall/vmexit so presumably the gpa should be considered stable
> across that call.  Is that not true?
>   

If you're in kvm.ko, then yes, that's a safe assumption to make because 
the guest VCPU cannot run while you are running.

But you're opening this interface to any caller so the VCPU is likely to 
be running while someone calls this function

> Regards,
> -Greg
>
>
>   


-- 
Regards,

Anthony Liguori

