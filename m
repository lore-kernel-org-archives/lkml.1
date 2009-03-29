Return-Path: <linux-kernel-owner+w=401wt.eu-S1757829AbZC2QK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829AbZC2QK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756459AbZC2QKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:10:37 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:62877 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315AbZC2QKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:10:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wL3AXFBhwnQaFSaIwqsqDvXaHqYQyCLwPoiJJr3hz76MLjy/M+viDLoZ846WTa0Mlu
         144wUO5jY1Tjzo7VnUWqzrcE2LIz/5MbtBYUFH/iNcpi3/mM0m2XwEz/er3kKZjH1Gq7
         sPoD8dmhItJOOO+dWt/X+94cK7vNCwNH2eJ1w=
Date: Mon, 30 Mar 2009 00:11:21 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] ptrace_vm: ptrace for syscall emulation virtual
	machines
Message-ID: <20090329161121.GD7671@hack>
References: <20090204080256.GC17452@cs.unibo.it> <20090310214456.GE5213@cs.unibo.it> <20090310220241.GC30475@elte.hu> <20090311134138.GD12753@cs.unibo.it> <20090316081508.GE3360@hack> <20090316121732.GC22978@cs.unibo.it> <20090318143939.GA3986@hack> <20090324232019.GG22695@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324232019.GG22695@cs.unibo.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 12:20:19AM +0100, Renzo Davoli wrote:
>Patch rebased on 2.6.29. I have fixed the code following Cong's suggestion.
>	renzo
>Although get_using_sysptvm is used as a boolean, I have left it int just 
>for the sake of simmetry with get_using_sysemu.
>It could be safely changed to boolean at any time.
>

Thanks.

My point is *not* changing it from 'int' to 'bool', I mean you
should change the interface, for example, change get_using_sysptvm()
to enable_sysptvm().

