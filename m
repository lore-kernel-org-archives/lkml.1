Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbZAMSzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbZAMSzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZAMSyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:54:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57740 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZAMSyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:54:54 -0500
Message-ID: <496CE36B.1030604@zytor.com>
Date: Tue, 13 Jan 2009 10:54:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - fix export private data to	userspace
References: <20090113183456.GA14470@localhost> <1231871832.16221.1.camel@brick> <20090113185013.GB14470@localhost>
In-Reply-To: <20090113185013.GB14470@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> I was concerning more about lilo side, is it use this param.
> So here is a link
> 
> 	http://lists.linuxcoding.com/kernel/2006-q3/msg18665.html
> 
> is seems LILO has it's own definition for COMMAND_LINE_SIZE.
> On the other hand it touches boot protocol. Peter should know
> if it safe to hide/change COMMAND_LINE_SIZE. Peter?
> 

Current x86 kernels export the command line size through the bzImage
header, and as such COMMAND_LINE_SIZE should not be used by userspace.

I can't speak for other architectures.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

