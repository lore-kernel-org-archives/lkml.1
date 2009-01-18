Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbZARUvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbZARUvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 15:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbZARUvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 15:51:47 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:47786 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbZARUvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 15:51:46 -0500
Date: Sun, 18 Jan 2009 21:53:30 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: auto-convert size types in userspace headers
Message-ID: <20090118205330.GC2978@uranus.ravnborg.org>
References: <49567EB5.5030409@zytor.com> <1230549153-31754-1-git-send-email-vapier@gentoo.org> <20081229140356.GB7327@uranus.ravnborg.org> <49595ED1.2080701@zytor.com> <20081230104351.GB486@uranus.ravnborg.org> <495A5D97.7070706@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495A5D97.7070706@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 09:42:47AM -0800, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> > On Mon, Dec 29, 2008 at 03:35:45PM -0800, H. Peter Anvin wrote:
> >> Sam Ravnborg wrote:
> >>> On Mon, Dec 29, 2008 at 06:12:33AM -0500, Mike Frysinger wrote:
> >>>> Rather than constantly fixing up size type breakage in userspace headers,
> >>>> auto convert the types u_intXX_t, uintXX_t, intXX_t, uXX, and sXX to the
> >>>> appropriate __uXX or __sXX type.
> >>> Is this the right thing to do?
> >>> uintXX_t belongs to a namespace that the kernel should not use.
> >>>
> >>> So being restrictive here would be better I think.
> >> That's the whole point right here.
> >>
> >> All of these types can be -- and are -- used by the kernel internally,
> >> but should only be exported as __uXX or __sXX.
> >>
> >> This is the auto-conversion idea I brought up earlier.
> > 
> > So the patch from Mike has your "Acked-by"?
> > 
> 
> Acked-by: H. Peter Anvin <hpa@zytor.com>

Hi hpa.

Despite your ack I chickened out on this one.
We have enough crunch in the userspace headers for now,
so lets see where we end with this before doing any autoconversion.

	Sam
