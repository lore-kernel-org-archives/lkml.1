Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbZA0S3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbZA0S3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbZA0S26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:28:58 -0500
Received: from outbound-mail-320.bluehost.com ([67.222.54.252]:32821 "HELO
	outbound-mail-320.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755205AbZA0S25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:28:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=I/OIm5z3e2WzNdi3dNl8UwTUZJZ/ZyVtGowtdZ8VqZlC6sgdHrc/yU7f+mJPCaFoJEzNMqCnVli+WeEOReoGylMIUVbz1doSzlmrBoD4NT2Ia/5fvAArD1vwMxGsKKFn;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Paul Rolland (=?utf-8?b?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
Subject: Re: Linux 2.6.29-rc2
Date: Tue, 27 Jan 2009 10:27:13 -0800
User-Agent: KMail/1.9.10
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0901161244310.4965@localhost.localdomain> <20090117193326.19471389@tux.DEF.witbe.net>
In-Reply-To: <20090117193326.19471389@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901271027.14189.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 17, 2009 10:33 am Paul Rolland wrote:
> Hello,
>
> On Fri, 16 Jan 2009 12:58:55 -0800 (PST)
>
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > It's out there now, or at least in the process of mirroring out.
>
> I'm getting this that I didn't have previously when running 2.6.28
> (and I think 2.6.29-rc1) :
>
> [drm:drm_wait_vblank] *ERROR* failed to acquire vblank counter, -22
> [drm:drm_wait_vblank] *ERROR* failed to acquire vblank counter, -22
>
> This seems to occur when X is running to turn off the screen due to
> inactivity...

This indicates that userspace was trying to wait for an event on a pipe that 
was disabled.  There are some fixes in Mesa to help avoid that (especially at 
app startup time); for the most part though they're harmless, since Mesa will 
eventually figure out which pipe to wait on and you won't see additional 
errors.

-- 
Jesse Barnes, Intel Open Source Technology Center
