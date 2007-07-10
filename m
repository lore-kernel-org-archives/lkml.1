Return-Path: <linux-kernel-owner+w=401wt.eu-S1761169AbXGJUsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761169AbXGJUsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763073AbXGJUsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:48:20 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50391 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762879AbXGJUsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:48:19 -0400
Message-ID: <4693F08B.5060904@zytor.com>
Date: Tue, 10 Jul 2007 13:48:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: x86 setup code rewrite in C
References: <200707102032.29124.a1426z@gawab.com>
In-Reply-To: <200707102032.29124.a1426z@gawab.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> H. Peter Anvin wrote:
>> This patch set replaces the x86 setup code, which is currently all in
>> assembly, with a version written in C, using the ".code16gcc" feature
>> of binutils (which has been present since at least 2001.)
>>
>> The new code is vastly easier to read, and, I hope, debug.  It should
>> be noted that I found a fair number of minor bugs while going through
>> this code, and have attempted to correct them.
> 
> I have an i810 which supends-to-ram just fine, but when booted over pxe it 
> just hangs.  Will these patches fix this, and if so, is there an easy 
> tar-ball against 2.6.22?

There is absolutely no way to know, other than testing it.  There isn't
any real reason to suspect the setup code in your case, but it's worth a
shot, I guess.

There is a git tree on git.kernel.org you can pull, which is current
against 2.6.22.

	-hpa
