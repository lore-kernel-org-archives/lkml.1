Return-Path: <linux-kernel-owner+w=401wt.eu-S932565AbXFGQCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565AbXFGQCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764954AbXFGQBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:01:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53881 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686AbXFGQBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:01:21 -0400
Date: Thu, 7 Jun 2007 09:01:07 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070607160107.GA17800@kroah.com>
References: <200706061421.l56ELDfB004305@harpo.it.uu.se> <4666D3F8.4010002@gmail.com> <20070606105650.bebf1c95.akpm@linux-foundation.org> <4666FBE8.3030103@gmail.com> <4667A93A.4060608@gmail.com> <4667AD3F.1010405@gmail.com> <4667AF20.4020209@gmail.com> <4667B095.5050508@gmail.com> <4667B241.801@gmail.com> <46682A25.5070409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46682A25.5070409@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 05:54:13PM +0200, Jiri Slaby wrote:
> Tejun Heo napsal(a):
> > Jiri Slaby wrote:
> >> Tejun Heo napsal(a):
> >>> Jiri Slaby wrote:
> >>>> Yes. Now I'm compiling -rc4-mm2.
> >>> It's probably caused by new sysfs slimdown patches and I'm pretty sure
> >>> -rc4-mm2 would fail the same way.  The offending one should be one of
> >>> the following patches.
> >> There's reverted gregkh-driver-block-device in -mm2. So I wanted to give it a
> >> try. Do you think it's pointless and that patch has no impact on the behaviour?
> > 
> > I'm not familiar with how lvm vgscan works and the patch does look like
> > it can affect that.  Please give a shot at -mm2.
> 
> Yup, it works without any further patches. So it seems like
> gregkh-driver-block-device is the culprit?

Culprit for what kind of symptom?  Is CONFIG_SYSFS_DEPRECATED enabled?
If not, can you try that?

thanks,

greg k-h
