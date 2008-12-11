Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYLKEOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYLKEOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 23:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYLKEOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 23:14:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:28477 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbYLKEOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 23:14:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nFtiYLH/WsTUmSsFHPJjvUHZO4UskkJLMVsD0vWyXwm08HvqhbopZTUpPhJH/NOYlV
         Gmt7VHCud3gp7Lam3p+BVJjfsbEQp/wMqrGeWAZHCSjbdc0G6ILn1+8SPWjBTtpKCbRC
         Zp3s5ulZFEjjCI93b6wpHk5P+UJBmh0NTjw0s=
Message-ID: <9cde8bff0812102014q1ad8f16arf5f4cda96fdf89db@mail.gmail.com>
Date: Thu, 11 Dec 2008 13:14:06 +0900
From: "Nguyen Anh Quynh" <aquynh@gmail.com>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] fix calls to request_module()
Cc: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       "Kuniyasu Suzaki" <k.suzaki@aist.go.jp>
In-Reply-To: <20081211040118.GK28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9cde8bff0812101935j5ef56140k67035d892a868738@mail.gmail.com>
	 <20081211040118.GK28946@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 1:01 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Dec 11, 2008 at 12:35:21PM +0900, Nguyen Anh Quynh wrote:
>> Hi,
>>
>> The request_module() function should always have the 1st param as a
>> format argument. So for example, request_module("i2c-powermac") should
>> be called as request_module("%s", "i2c-powermac"). Otherwise, new gcc
>> like gcc 4.3.2 on Ubuntu 8.10 would spit out a lot of warnings. This
>> patch fixes them all in linus-git tree.
>
> ... and it doesn't address the underlying problems at all.  A string literal
> without a single % in it is a perfectly sane and valid format.  _Why_ are
> we getting these warning?

Hmm, I checked again, and the warnings actually lie elsewhere. I got
mistake while work with several versions at the same time. So please
ignore this patch.

Thanks,
Quynh
