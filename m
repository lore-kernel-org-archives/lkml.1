Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbYHGW4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbYHGW4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYHGWz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:55:59 -0400
Received: from outbound-mail-108.bluehost.com ([69.89.22.8]:40224 "HELO
	outbound-mail-108.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753188AbYHGWz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:55:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=qjbIlQD2gSyxcfbXriS437InJkt4aFIvkENuHpNlQSOdDit0lVAJOo3JtLm3kdLs7OEHSp/3fKWlxrt0YPk8fORIXk3boMpIYr7fz6x3FR+Eg0iU7DPtkrb53mTtcX3J;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Linux 2.6.27-rc2] suspend to disk, libata problem
Date: Thu, 7 Aug 2008 15:55:41 -0700
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bzolnier@gmail.com, linux-ide@vger.kernel.org, jgarzik@pobox.com,
       Matthew Wilcox <matthew@wil.cx>
References: <8db1092f0808071530o2f41b1b9p227dbb920e0a3961@mail.gmail.com> <alpine.LFD.1.10.0808071541150.3462@nehalem.linux-foundation.org> <200808080052.03443.rjw@sisk.pl>
In-Reply-To: <200808080052.03443.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808071555.42088.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 7, 2008 3:52 pm Rafael J. Wysocki wrote:
> On Friday, 8 of August 2008, Linus Torvalds wrote:
> > On Fri, 8 Aug 2008, Maciej Rutecki wrote:
> > > I have problem with suspend to disk. On 2.6.26.* works fine.
> > >
> > > During s2disk i have this messages (with "no_console_suspend" kernel
> > > option): http://unixy.pl/maciek/download/kernel/2.6.27-rc2/img_0005.jpg
> > > (hibernation fails)
> > >
> > > Config, dmesg (normal booting):
> > > http://unixy.pl/maciek/download/kernel/2.6.27-rc2/
> >
> > Any chance to get this bisected? I realize that it's quite a few reboots,
> > and _maybe_ Jeff or Bartlomiej can just say "oh, duh, it's because of
> > Xyz", but the more likely thing is that without a bisect people will be
> > flailing around fairly blindly..
>
> Looks like another incarnation of
> http://bugzilla.kernel.org/show_bug.cgi?id=11178
>
> Maciej, can you try the patch at
> http://bugzilla.kernel.org/attachment.cgi?id=17043&action=view
> please?

I just pushed this fix into my for-linus tree.  I wanted it (along with the 
rest of my for-linus stuff) to get one day in linux-next before asking Linus 
to pull it though...

Jesse
