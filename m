Return-Path: <linux-kernel-owner+w=401wt.eu-S935305AbXHIHWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935305AbXHIHWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 03:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759620AbXHIHWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 03:22:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45317 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758086AbXHIHV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 03:21:59 -0400
Message-ID: <46BAC093.1000503@zytor.com>
Date: Thu, 09 Aug 2007 00:21:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: jidong xiao <jidong.xiao@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Question on IS_ERR
References: <4104961b0708082236if0c1199l2bbc468e9d582a08@mail.gmail.com>	 <46BAB078.4020307@zytor.com> <4104961b0708082331h4f868113g9a9e76905883619b@mail.gmail.com>
In-Reply-To: <4104961b0708082331h4f868113g9a9e76905883619b@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jidong xiao wrote:
> On 8/9/07, H. Peter Anvin <hpa@zytor.com> wrote:
>> No.  There is no requirement that the pointer is page-aligned.  The last
>> page of the address space is (in the Linux kernel) invalid by
>> definition, so there are in effect three kinds of pointers in the Linux
>> kernel: valid pointers, NULL, and ERR_PTR()s.
>>
>>        -hpa
>>
> 
> Regarding "The last page of the address space is invalid by definition",
> I am wondering why do we define the last page as invalid.
> The reason for defining this is just because we want to take use of
> the error number handling?
> 

Pretty much.

	-hpa
