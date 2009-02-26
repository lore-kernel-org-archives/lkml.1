Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbZBZGvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbZBZGvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 01:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZBZGvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 01:51:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:61311 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZBZGvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 01:51:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vuDcdd3Nsf0zjzkvCPSMsQuElq9HxvqV0y5t4lWYs9vP01f4xdTG2VK6PmPdAdyxm5
         5QqSnacTWHLVLv2t0ATbdnMQ/10UADB2HghtZ1x7w8ayv0N1hHmHRcrXEAofUuDv1Lma
         UvsQ1ml6dQGnoAS88NxD5CKmfhgm+bdP2Q3y8=
MIME-Version: 1.0
In-Reply-To: <49A62899.4080001@zytor.com>
References: <20090225205920.GA22091@localhost> <20090226030315.GB7526@elte.hu>
	 <1235617541.5610.0.camel@brick> <20090226031301.GE7526@elte.hu>
	 <1235618574.5610.1.camel@brick> <20090226032544.GB22223@elte.hu>
	 <49A62899.4080001@zytor.com>
Date: Thu, 26 Feb 2009 09:51:36 +0300
Message-ID: <aa79d98a0902252251p4476fa83ndc2d3286e7b27094@mail.gmail.com>
Subject: Re: [RFC] introduce pr_cont macro
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 8:28 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Ingo Molnar wrote:
>>
>> Btw., why do those macros use ##__VA_ARGS__ ? Why not a straightforward:
>>
>>  #define __pr_cont(args...) \
>>        printk(KERN_CONT args)
>>
>
> Don't know if anyone cares, but __VA_ARGS__ is C99 whereas args... is a gcc
> extension, AFAIK.
>
>        -hpa
>

I think in a sake of consistency better would be using __VA_ARGS__ here
too (since all prevous pr_...'s use it).
