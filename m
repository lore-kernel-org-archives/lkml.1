Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbYKKSOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbYKKSOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:14:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbYKKSNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:13:47 -0500
Received: from outbound-mail-118.bluehost.com ([69.89.22.18]:54783 "HELO
	outbound-mail-118.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754862AbYKKSNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:13:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=HFCHh512BSqlkvEiIxajvAbEHnR8JLA4GFnn4VDx289A3DsuTiaZBss+biTM0lgYdqA2CndV9cmHHX5ofynPFM6Qi9OtjwimetsJMYPQ+VDNOpDH1/5F/SDrOmi4RDwl;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: [git pull] drm fixes for 2.6.27-rc5
Date: Tue, 11 Nov 2008 10:13:34 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.26.6-79.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Dave Airlie" <airlied@linux.ie>, torvalds@linux-foundation.org,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
References: <alpine.DEB.0.82.0811110811350.2182@skynet.skynet.ie> <20081111002958.7620fb56.akpm@linux-foundation.org> <21d7e9970811110037l49e7b28bl2480863682cda0c@mail.gmail.com>
In-Reply-To: <21d7e9970811110037l49e7b28bl2480863682cda0c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811111013.35358.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 11, 2008 12:37 am Dave Airlie wrote:
> On Tue, Nov 11, 2008 at 6:29 PM, Andrew Morton
>
> <akpm@linux-foundation.org> wrote:
> > On Tue, 11 Nov 2008 08:15:26 +0000 (GMT) Dave Airlie <airlied@linux.ie> 
wrote:
> >> commit 78538bf14995a136c2d9a22159ada49937359119
> >> Author: Dave Airlie <airlied@linux.ie>
> >> Date:   Tue Nov 11 17:56:16 2008 +1000
> >>
> >>     drm/radeon: map registers at load time
> >>
> >>     Now that the radeon driver has suspend/resume functions, it needs to
> >> map its registers at load time or it will likely crash if a suspend
> >> operation occurs before the driver has been initialized.
> >>
> >>     This patch moves the register mapping code from firstopen to load
> >> and makes the mapping into a _DRM_DRIVER one so that the core won't
> >> remove it at lastclose time.
> >
> > Does this make the below patch obsolete?
>
> Yes please drop this, the correct fix is the one Jesse posted + a fix
> on top of it I made in the same patch.

Oh geez, yeah that's ugly, thanks for catching it.

Jesse
