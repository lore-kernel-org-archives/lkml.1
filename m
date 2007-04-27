Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbXD0C2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbXD0C2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 22:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbXD0C2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 22:28:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:20743 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbXD0C2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 22:28:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=qD7QmgZ11M9qbxLYnYFcfn45NbHZZeXATlrpZDTrmnrEo6Co7cRFnuctlkBTPHgEoHYhOaAMjLffxCk2+jCGaZ0rYrTFiLSamWMvQL/QgKGd9V3IjQ5Xz4MJdfe6WCZ8d5mPabUjxlZcFLwZui84Fg7Au5X+LhKp4JQXxszu7IY=
Date: Fri, 27 Apr 2007 10:32:52 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michael McConnell <soruk@eridani.co.uk>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: MAINTAINERS file out of date?
Message-ID: <20070427023252.GA3797@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	Michael McConnell <soruk@eridani.co.uk>,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>
References: <4631255F.9010902@eridani.co.uk> <463131FD.8020301@zytor.com> <20070427010914.GA2570@localhost.localdomain> <46314E0B.1020800@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46314E0B.1020800@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 06:12:43PM -0700, H. Peter Anvin wrote:
>WANG Cong wrote:
>>>
>>> I have considered myself as a rather unofficial maintainer of this code,
>>> and wouldn't mind make it official now when I actually have a job which
>>> both cares about and actually can support my upstream Linux activities,
>>> which was a major pain for a while.
>>>
>>> Overall, there is a lot of cleanup which really is needed in the i386
>>> boot process; I have done some work on it already, but more is needed.
>> 
>> Sounds interesting. Can you point me what needs to be done exactly? Maybe I can help you. ;)
>
>There was a long thread on the linux-virtualization list
>(@lists.linux-foundation.org) just a few days ago.  The biggest single
>issue right now is probably how we transition from the bootup page
>tables to the "real" init_mm page tables, but the real-mode code also
>needs a massive overhaul (especially so since this code can and should
>be shared with x86-64); in particular I really want to get rid of the
>insane segment handling, where segments are constantly recalculated for
>no good reason.
>
>For the real-mode stuff, I have some patches already in the works for
>this.  Eric W. Biederman has also done a lot of work in this area.
>
>	-hpa

Thanks for your point. 
I know little about virtualization, maybe can't help much. But I am interested in other things you mentioned. AFAIK, segments can't be avoided on i386, and Linux uses them very little, how are they recalculated constantly?

Regards!

