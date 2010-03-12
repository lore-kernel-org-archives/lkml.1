Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab0CLXoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 18:44:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932385Ab0CLXoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 18:44:20 -0500
Date: Fri, 12 Mar 2010 15:44:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Daniel Taylor <Daniel.Taylor@wdc.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 2/2] fs/partition/msdos: Fix unusable extended partition
 for > 512B sector
Message-Id: <20100312154415.a2f8f944.akpm@linux-foundation.org>
In-Reply-To: <4B996A05.1030907@zytor.com>
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com>
	<20100301141335.395dc4c3.akpm@linux-foundation.org>
	<873a0h1p2c.fsf@devron.myhome.or.jp>
	<876358iehd.fsf@devron.myhome.or.jp>
	<4B9430B6.701@zytor.com>
	<87pr3fd68r.fsf@devron.myhome.or.jp>
	<4B9440FC.3090502@zytor.com>
	<87zl2j9muz.fsf@devron.myhome.or.jp>
	<87wrxkw52s.fsf_-_@devron.myhome.or.jp>
	<87sk88w4xk.fsf_-_@devron.myhome.or.jp>
	<3E0C3AE547FA504DA5E89EA5A24AC85803E2BD87@wdscexbe01.sc.wdc.com>
	<873a07oyts.fsf@devron.myhome.or.jp>
	<3E0C3AE547FA504DA5E89EA5A24AC85803E2BD8E@wdscexbe01.sc.wdc.com>
	<4B99677B.80001@zytor.com>
	<3E0C3AE547FA504DA5E89EA5A24AC85803E2BD91@wdscexbe01.sc.wdc.com>
	<4B996A05.1030907@zytor.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 14:09:09 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 03/11/2010 02:06 PM, Daniel Taylor wrote:
> >
> > BIOS failures prior to loading the kernel are not Linux'
> > responsibility.  Confused BIOS will still fail, even if the
> > patch is not implemented,  so how does that effect the
> > acceptance of a patch that fixes post-boot behavior?
> >
> 
> I didn't say it does.
> 
> >>
> >> I would consider this a bugfix.  As such, it should be pushed outside
> >> the merge window.
> >>
> 
> Just in case I wasn't clear enough -- this patch is a bugfix and should 
> be pushed upstream as long as it is technically ready.
> 

yeah.  In fact I tagged it for -stable backporting.  Because as Daniel
says, "In the near future, WD will be releasing products that need this
patch".  People will surely want to use 2.6.33.x-based kernels with
those devices, so packagers of 2.6.33.x-based kernels will need to hunt
down and apply this patch.  So let's do it for them.

