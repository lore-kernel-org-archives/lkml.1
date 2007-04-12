Return-Path: <linux-kernel-owner+w=401wt.eu-S1422636AbXDLEQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422636AbXDLEQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 00:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422639AbXDLEQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 00:16:27 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:46235 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422636AbXDLEQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 00:16:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=moKGTHABy3/7lF8bsC+adgDi/Kn2urk+NfhZEsZ96FKfRJNEgKeSghNyPw1pGyAaw3UcONz9RiNSwL1scmsq5YWfTrKieXvxTjw4DEOiGB2gGt2uaLnhpcwkveTZXFkDxRqykiviM0lKc5n0fjVGyXrSlBC1JwmchzhzPlJOwv4=
Message-ID: <b6a2187b0704112116u6bb3a344o2e02d6d612d0fcf7@mail.gmail.com>
Date: Thu, 12 Apr 2007 12:16:25 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc6
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704100833250.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
	 <b6a2187b0704100735s733e2499k421e27cf650001f8@mail.gmail.com>
	 <Pine.LNX.4.64.0704100833250.6730@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Tue, 10 Apr 2007, Jeff Chua wrote:
> > I couldn't get suspend-to-disk to work with 2.6.21-rc6. I've tried
> > set/unset CONFIG_NO_HZ/CONFIG_HPET_TIMER, but nothing worked.
>
> Do you think you could busect it? You'd have to apply maxim's patch by
> hand at each bisection step (up until the point where it's already applied
> in the git tree, of course), so it's not a totally mindless bisection, but
> it should still be fairly painless, since there is only 277 commits
> between -rc5 and -rc6 (so bisection should rather quickly narrow it down)

Linus,

I did that last night and realize that I could suspend to disk/ram
with 2.6.21-rc6  CONFIG_NO_HZ unset. I must have done something wrong
before.

Thank you,
Jeff.
