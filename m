Return-Path: <linux-kernel-owner+w=401wt.eu-S932891AbYBWLTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbYBWLTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 06:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYBWLS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 06:18:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:62628 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbYBWLS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 06:18:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CAbS7Du02qUvDZHgIqR8aE5N/s0svybl5sZwzjV7S9N5k+qE95d46gZ7Rg6TPPgE+7bZQyB2+WuoVmkoQ9wussuBgwLO5YuEbOVZ81BvAC6jgJL1DQwEO43/4OJfftH9TTdb+r6jtt7dNv1IN2LQ9bfioBVs69hlFF+xLh+MxII=
Message-ID: <84144f020802230318hec5fe97h84c797a56b0dd5db@mail.gmail.com>
Date: Sat, 23 Feb 2008 13:18:57 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "Michael Buesch" <mb@bu3sch.de>, "Alexey Zaytsev" <zaytsev.a@protei.ru>,
       "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080223110751.GN23833@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru> <200802221513.58608.mb@bu3sch.de>
	 <47BF101F.30301@protei.ru> <200802221848.37902.mb@bu3sch.de>
	 <20080223110751.GN23833@elte.hu>
X-Google-Sender-Auth: 5b7af3a849194706
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 1:07 PM, Ingo Molnar <mingo@elte.hu> wrote:
>  I have to say, after having observed multiple incidents around b43 in
>  the past few months you are one of the worst driver maintainers i've
>  ever seen on lkml: you are ignoring regressions, you are frequently
>  insulting our testers and now you even have the gall to NAK a patch to
>  _your own buggy driver code_ without providing an alternative fix.
>  Kudos.

Agreed. Alexey, did you identify a specific git commit that caused the
regression? Can we just revert that from 2.6.24? Michael, even if
_you're_ planning to remove bcm43xx we must not let it regress until
it's gone.
