Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbXFPJI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbXFPJI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 05:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbXFPJIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 05:08:49 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:58537 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbXFPJIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 05:08:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mm56bbq6/SWxKAPyrivu2LF9liPkx8qkE/xI1MWBvZ35PZ9fTu3pDpli3NaXFLVooC2qVZMu4SBH9bOY4fILT9IXGHO667MUzh1MUTPq47YRLooitpGeao/cLA1hV76+dblDUbUahgo9le+2WJlBXGLJ+ZeFys0bPG8WqAqbnXw=
Message-ID: <787b0d920706160208u62f8a2c5q5f94f5986d755d24@mail.gmail.com>
Date: Sat, 16 Jun 2007 05:08:46 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [TOMOYO 5/9] Memory and pathname management functions.
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       takedakn@nttdata.co.jp, hch@infradead.org
In-Reply-To: <20070615130000.GI9442@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920706150016n3e941a4fj4fc2e864a7e6f7d7@mail.gmail.com>
	 <20070615130000.GI9442@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/07, Pavel Machek <pavel@ucw.cz> wrote:
> [Albert Cahalan]

> > It's really not worth getting bothered by. Truth is, big
> > giant
> > pathnames break lots of stuff already, both kernel and
> > userspace.
>
> > Just look in /proc for some nice juicy kernel breakage:
> > cwd, exe, fd/*, maps, mounts, mountstats, root, smaps
>
> Well, but we should be fixing that, not adding more. And /proc is
> info-only, while this is security related code.

Security tools read from /proc, so /proc is security-related.

The limit imposed by TOMOYO (or AppArmor) is fine,
despite being security-related. It just needs to fail in
the safe direction: access denied.
