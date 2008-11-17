Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763AbYKQNzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbYKQNzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYKQNzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:55:41 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:21329 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbYKQNzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:55:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Y6ZwamdKKftcWFbZRNAVc3bXcW8N5erXMKmA1LhcZwDkuzWDXlZj5F4vj+p9TmEftf
         //B5ncixpP7Gt92nvUcTAUj1I8w0WdYLkcPq21OBdetTADckPHPtFRczbunGVXdi3gl2
         o8X5ygeg7cz6l5tAwvanQU84iRtYbHDC7l+7Q=
Message-ID: <3aaafc130811170555l7e35b6b9s169d03f23eeb6388@mail.gmail.com>
Date: Mon, 17 Nov 2008 08:55:40 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Victoria Muntean" <vikimun@gmail.com>
Subject: Re: size of swapped-out part of the process
Cc: "Kernel Linux" <linux-kernel@vger.kernel.org>
In-Reply-To: <ab4346860811170547j6f21ba2ducd451e761e165a5d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab4346860811170452t2cbcb451u407edca19c9e0ba6@mail.gmail.com>
	 <ab4346860811170453i2bba95a6nb16c2c9e59424272@mail.gmail.com>
	 <3aaafc130811170533j4c7e0008vd76c42da0cbb9f36@mail.gmail.com>
	 <ab4346860811170547j6f21ba2ducd451e761e165a5d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 8:47 AM, Victoria Muntean <vikimun@gmail.com> wrote:
> On Mon, Nov 17, 2008 at 3:33 PM, J.R. Mauro <jrm8005@gmail.com> wrote:
>> On Mon, Nov 17, 2008 at 7:53 AM, Victoria Muntean <vikimun@gmail.com> wrote:
>>> How can I calculate size of swapped-out part of the process from
>>> /proc/PID/*, even if approximately ?
>>> For example, I have VmSize=1216192 kB, VmRSS = 628788 kB, but global
>>> swap-in-use==0.
>>> Hence (VmSize - VmRSS) is far from being swapped-out part of the
>>> process. What is ?
>>
>> Doesn't top's SWAP field give you this?
>
> No. SWAP is global. I need per-process. Per-process participation in swap.
>

Are you sure? I'm not talking about the Swap: BigNumber in the header.
If you hit f you can add a SWAP column which is per process. Or if it
isn't per-process, it's horribly misleading.
