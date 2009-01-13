Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbZAMSvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbZAMSvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbZAMSuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:50:18 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:59714 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218AbZAMSuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:50:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YaTCMDUx4kK+rluZFCSIvLtc9jnlPSuGn4HfRUTpa6N5II5TwDScXqz3tgKke9afTf
         Fv2cYa5S/071oww/A3tVXCcLg7KB6/2t/cdvxARRZHHYWcCqI0FybV0U/9efj0reZ8wG
         NnUSquuUoYXGwm0BmlmVrkg5fTpQkl6jKTe3A=
Date: Tue, 13 Jan 2009 21:50:13 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - fix export private data to
	userspace
Message-ID: <20090113185013.GB14470@localhost>
References: <20090113183456.GA14470@localhost> <1231871832.16221.1.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231871832.16221.1.camel@brick>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Harvey Harrison - Tue, Jan 13, 2009 at 10:37:12AM -0800]
| On Tue, 2009-01-13 at 21:34 +0300, Cyrill Gorcunov wrote:
| > Impact: cleanup
| 
| > 4) setup.h - COMMAND_LINE_SIZE saved for userspace, bootloaders
| >    could use it.
| 
| Doesn't this need to be (at least) _COMMAND_LINE_SIZE to avoid
| polluting the namespace, not sure it can be changed though as the
| horse is already out of the barn.
| 
| Harvey
| 

I was concerning more about lilo side, is it use this param.
So here is a link

	http://lists.linuxcoding.com/kernel/2006-q3/msg18665.html

is seems LILO has it's own definition for COMMAND_LINE_SIZE.
On the other hand it touches boot protocol. Peter should know
if it safe to hide/change COMMAND_LINE_SIZE. Peter?

		- Cyrill -
