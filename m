Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbZIJGoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbZIJGoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 02:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZIJGoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 02:44:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49300 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbZIJGoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 02:44:06 -0400
Message-ID: <4AA89FDA.3090105@kernel.org>
Date: Wed, 09 Sep 2009 23:42:34 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 0/2] __builtin_unreachable
References: <20090910015923.8FB628AE5F@magilla.sf.frob.com> <2375c9f90909092142i58595fedod6780a7c41190f5f@mail.gmail.com>
In-Reply-To: <2375c9f90909092142i58595fedod6780a7c41190f5f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 09:42 PM, Américo Wang wrote:
> 
> Just curious, what different asm code will gcc generate for this? Comparing it
> to for(;;) ? I am sorry that I don't have gcc 4.5 on hand.
> 

It generates nothing.  It is you as the programmer guaranteeing that we
will never get there, and as such gcc will generate no code at all.

	-hpa
