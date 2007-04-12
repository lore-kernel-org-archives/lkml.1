Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbXDLXbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbXDLXbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbXDLXbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:31:42 -0400
Received: from gw.goop.org ([64.81.55.164]:44983 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbXDLXbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:31:40 -0400
Message-ID: <461EC138.10407@goop.org>
Date: Thu, 12 Apr 2007 16:31:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Tim Yamin <plasmaroo@gentoo.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH UPDATE] deflate stack usage in lib/inflate.c
References: <461DED14.1070603@goop.org> <461E9BAD.8050202@goop.org> <200704122321.23318.ak@suse.de> <461EB515.4080106@goop.org> <Pine.LNX.4.61.0704130119470.14441@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704130119470.14441@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Apr 12 2007 15:39, Jeremy Fitzhardinge wrote:
>   
>> Andi Kleen wrote:
>>     
>>> Hmm, does Xen perhaps not use interrupt stacks? Normally 2.7k should be still
>>> green as long as there are not too many functions above/below it.
>>>       
>> That's a good point, I'll need to check that.  Still, nearly 3k of stack!
>>     
>
> I bite. Would compressing the vmlinux binary with LZO or LZMA make an
> improvement to the bootstrap uncompress stack usage?
>   

Well, the thread started with my patch to fix inflate.  The stack usage
of LZO or LZMA decompressors will primarily depend on how they're
implemented rather than any inherent property of the algorithms.

    J
