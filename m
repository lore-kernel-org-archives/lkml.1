Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbZBQNHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbZBQNHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 08:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbZBQNHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 08:07:11 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:54987 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZBQNHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 08:07:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Bae0UfAfpXY9qPSQH0HM5vOu0/2ikF6bOd2YM4dQVnldxUpi74UGyfsNYQMj210UXB
         e3MGtQp+qOTCYAgzLx9VDOYZT3xR1/kNH1wSxRIuXcT6Y7QOW+ayzSWrlPnojRhG96tb
         DrPeb1dzXkeMRSvKAP19tGpnkrS5wkkGx9B5w=
Date: Tue, 17 Feb 2009 21:07:09 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Luca Bigliardi <shammash@artha.org>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, jdike@addtoit.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix vde network backend in user mode linux
Message-ID: <20090217130709.GE3505@hack.private>
References: <20090202172822.GA2801@pintsize> <alpine.LNX.1.10.0902161334250.18110@jikos.suse.cz> <20090216124939.GC23665@hack.private> <20090216132344.GN24031@pintsize>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090216132344.GN24031@pintsize>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 02:23:45PM +0100, Luca Bigliardi wrote:
>On Mon, Feb 16, 2009 at 08:49 PM, Américo Wang wrote:
>
>> On Mon, Feb 16, 2009 at 01:38:46PM +0100, Jiri Kosina wrote:
>> >
>> >[ doesn't seem to be picked up by anyone into current -next nor -mmotm, 
>> >  but isn't appropriate for trivial; adding akpm to cc ]
>> >
>> >On Mon, 2 Feb 2009, Luca Bigliardi wrote:
>> >
>> >> * Replace kmalloc() with uml_kmalloc()
>> >>   (fix build failure)
>> 
>> 
>> Weird... I sent a patch for this several months ago! I thought
>> Jeff had already taken it... No?
>
>I did as well (in June/July 08 IIRC) through usermodelinux-devel mailing
>list but the patch didn't hit, so this time I've tried this way.

The problem is _not_ that I don't like you to fix it again, it _is_
that Jeff said he queued a same patch[1] but he didn't push it. :)

1. http://lkml.org/lkml/2008/7/23/142


>
>> >> * Remove unnecessary UM_KERN_INFO in printk()
>> >>   (don't display '<6>' while printing info)
>> 
>> But why only this one, not other UM_KERN_INFO in the same file?
>
>Other lines are preceded by a 'new_text_line' so vprintk 'eats' the token.

Ok then, thank you!

Reviewed-by: WANG Cong <wangcong@zeuux.org>


-- 
"Against stupidity, the gods themselves, contend in vain."

