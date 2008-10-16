Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYJPQba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYJPQba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 12:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYJPQbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 12:31:21 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:19767 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYJPQbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 12:31:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YL/HutBVFAmiCSUA5Coj57tzZ7A8ItnmKreJpy5dUY0+PVFmCay9yZSKH5y01eRVL/
         pakPd+k+hLdp7wVXK8WUkSQts56669e7WiLLqiqhcyE1GHrMuHPrBPZuzipNeJFVCCLd
         UpNzMJq7A1sCrioZsij0rldZSVGWoYLbEw9Uk=
Message-ID: <df9815e70810160931s86c9058rc18d426ce278aa30@mail.gmail.com>
Date: Fri, 17 Oct 2008 00:31:18 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: questions about rd{msr|tsc|pmc} instruction with x86-64
Cc: gcosta@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <48F6E1A7.2070602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <df9815e70810152330h7886c77arb01e1fd308b4a7ae@mail.gmail.com>
	 <48F6E1A7.2070602@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 2:39 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Jike Song wrote:
>> {snip}
>
> "A" means rdx:rax on x86-64, not edx:eax.  For a 64-bit number, it means,
> literally, "one of rdx or rax"!  As you correctly point out, this is not how
> rdmsr works.
>
>        -hpa
>

Thanks, Peter!  So I misunderstood the gcc constraint 'A' for x86-64,
but seems the comment "while x86_64 returns at rax" still wrong,
should this be fixed?

-- 
Thanks,
Jike
