Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbYANVxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbYANVxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYANVxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:53:10 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:57627 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbYANVxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:53:09 -0500
Date: Mon, 14 Jan 2008 23:52:09 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Oliver Pinter =?utf-8?B?KFBpbnTDqXIgT2xpdsOpcik=?= 
	<oliver.pntr@gmail.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, gregkh@suse.de
Subject: Re: [BUG] skge 0000:02:05: read data parity error
Message-ID: <20080114215209.GK9847@does.not.exist>
References: <6101e8c40801141157j1ce7d3f0if2e4eb2344b6c844@mail.gmail.com> <20080114125200.28cb4c69@deepthought> <20080114210105.GG9847@does.not.exist> <6101e8c40801141331n3cb66c04pc74ff07faf04c8fd@mail.gmail.com> <20080114213453.GJ9847@does.not.exist> <6101e8c40801141341hcb17b08h2fd5244bccb21928@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6101e8c40801141341hcb17b08h2fd5244bccb21928@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 10:41:52PM +0100, Oliver Pinter (Pintér Olivér) wrote:
> On 1/14/08, Adrian Bunk <bunk@kernel.org> wrote:
> > On Mon, Jan 14, 2008 at 10:31:03PM +0100, Oliver Pinter (Pintér Olivér)
> > wrote:
> > > I think, it is a potential security breakpoint, when applications with
> > > root permission its read, then a machine is freezed, or only i thin
> > > it's?
> >
> > When you are root there are infinite ways to kill your machine, so
> > there's nothing security related about this issue.
> 
> Yes, i know, but when some application or daemons read some file with
> running root privileges, then ...
> 
> thanks, then it is only a "feature" and not bug.

It might be a bug in the application.

But there are worse things than crashing your machine (e.g. getting your 
/etc/shadow) that can happen when someone with bad intentions can read 
files with root privileges.

> Thanks,
> Oliver

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

