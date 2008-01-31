Return-Path: <linux-kernel-owner+w=401wt.eu-S933706AbYAaQYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706AbYAaQYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761186AbYAaQYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:24:40 -0500
Received: from hu-out-0506.google.com ([72.14.214.226]:6914 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789AbYAaQYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:24:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=lPe6OYcdAsYfuMyGMXn7rZ+H3mIcaY4wQIhUqSGveHcZZ92gMj/sQAksdWF209DDs39rwanmgia3sazGFmhR9Q9XphhhNJRS/5efyRXtOrQ2nmnX/qo0m6iY8KckpJ6KG4eZ76ZUanauei6+bFVlOD86VIbh6pO8TPJtr5uacoQ=
Date: Fri, 1 Feb 2008 00:21:49 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Message-ID: <20080131162149.GF2471@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080130011550.GA31853@elte.hu> <20080131155739.GA19700@cs181133002.pp.htv.fi> <20080131160033.GA11501@elte.hu> <20080131161235.GB19700@cs181133002.pp.htv.fi> <20080131161523.GA12347@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131161523.GA12347@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 05:15:23PM +0100, Ingo Molnar wrote:
>
>* Adrian Bunk <bunk@kernel.org> wrote:
>
>> On Thu, Jan 31, 2008 at 05:00:33PM +0100, Ingo Molnar wrote:
>> > 
>> > * Adrian Bunk <bunk@kernel.org> wrote:
>> > 
>> > > You tested x86 but broke more than half a dozen other archtectures, 
>> > > with at least 3 different commits breaking other architectures.
>> > 
>> > Note that all known breakages are fixed in current -git, except for the 
>> > s390 problem that Martin/Nick posted the fix.
>> 
>> What about the breakages caused by commit 
>> a5a19c63f4e55e32dc0bc3d936d7f94793d8b380 (this commit broke the 
>> defconfig compilation on at least avr32, blackfin, sh, sparc and uml)?
>
>the patch below fixes that.
>

I just send the same patch[1] minutes ago. ;-)

1. http://lkml.org/lkml/2008/1/31/223

