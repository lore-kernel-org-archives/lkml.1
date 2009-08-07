Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZHGRUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZHGRUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZHGRUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:20:08 -0400
Received: from outbound-mail-28.bluehost.com ([69.89.17.198]:41989 "HELO
	outbound-mail-28.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752183AbZHGRUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:20:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=JguFvplKplqL7iaaUxsQa01jGwjh2W/G1AR36nSafb3998U8jH3SC5dgKSeG3+fQiN94zLryGi1gVo7Vg4tZvroPmOAcwqlzVPPBMkbPEi255OngxifxcfoI5q2KPCYx;
Date: Fri, 7 Aug 2009 10:20:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG 13180]: Warning at i915_gem_idle
Message-ID: <20090807102005.67800b3b@jbarnes-g45>
In-Reply-To: <4A721077.9020607@gmail.com>
References: <4A721077.9020607@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009 23:28:23 +0200
Niel Lambrechts <niel.lambrechts@gmail.com> wrote:

> Hi Rafael,
> 
> I just noticed you already opened a previous bugzilla entry for a 
> problem I'm seeing again (below) at 
> http://bugzilla.kernel.org/show_bug.cgi?id=13180. Is it perhaps
> possible that you can re-open it, it is recurring in 2.6.30.2 up to
> 2.6.31-rc4 again?
> 
> X is intermittently soft-freezing and at other times I notice Xorg is 
> 100% busy, it could be at the same time than this message I'm not 
> absolutely certain. It seems to happen either during a screen-saver 
> period or auto-suspend to RAM.
> 
> Previously, Andrew had the following comment:
> > That is
> >
> > 		WARN_ON(!list_empty(&dev_priv->mm.flushing_list));
> >
> > Does the warning persist in 2.6.30-rc3 or later?  If so, we should
> > add it to the post-2.6.29 regression list (if there's any room
> > left). 
> 
> So I'd like to request that it be added to the regression list for 
> 2.6.30 and 2.6.31...

Niel, can you move or file a bug for this at bugs.freedesktop.org
against drm/intel?  We try to track gfx bugs there... I assume you
still see this with -rc5?

-- 
Jesse Barnes, Intel Open Source Technology Center
