Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbZDVLiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbZDVLiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 07:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZDVLin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 07:38:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56793 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbZDVLim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 07:38:42 -0400
Message-ID: <49EF01B4.6000406@redhat.com>
Date: Wed, 22 Apr 2009 07:38:28 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Anders Kaseorg <andersk@MIT.EDU>
CC: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
       Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH v2 0/4] Add support for compiling with	-ffunction-sections
 -fdata-sections
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <20090421140228.GC3303@hack> <alpine.DEB.2.00.0904211311110.7725@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.2.00.0904211311110.7725@vinegar-pot.mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders Kaseorg wrote:
> On Tue, 21 Apr 2009, Américo Wang wrote:
>> Nice work! But, don't -ffunction-sections and -fdata-sections have
>> collisions with '-g' and 'gprof'? Just like what gcc(1) describes.
> 
> That description seems to be long obsolete.  gcc used to warn that 
> -ffunction-sections may affect debugging, but that warning was disabled 
> for ELF targets in 1999, presumably because ELF has always supported 
> arbitrary section names even though some other object formats have issues.
>   <http://gcc.gnu.org/ml/gcc-patches/2008-03/msg00975.html>
> 
> I know that debugging under -ffunction-sections -g works fine on at least 
> x86, which is the only platform on which we currently propose to provide 
> this option, and based on that message it looks like other platforms are 
> fine too.

Would you know actual version of gcc from which supports the combination of
-ffunction-sections and -g?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

