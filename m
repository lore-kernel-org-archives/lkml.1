Return-Path: <linux-kernel-owner+w=401wt.eu-S1763452AbXHVO3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763452AbXHVO3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760145AbXHVO3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:29:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:22693 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759460AbXHVO3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FizJULrmtY71aCP7Eo4tv2xhah/wDJm0N1GfDB0iRHk+q2NNi7t5zNr2b6hCnRg7NtgR1/WBvRR+uku+BYeyr+Wd5ZsODqekld7Xu6CrIKTVwfu29ptrpZ0n3jFfF2tyhdyJnXBw3CJaE1gSV23j4SB5yjqa6VrSYRYfpIBNakY=
Message-ID: <6bffcb0e0708220729j7b9afcf3v4edef68cc974c08d@mail.gmail.com>
Date: Wed, 22 Aug 2007 16:29:40 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "James Morris" <jmorris@namei.org>
Subject: Re: [2.6.20.17 review 00/58] 2.6.20.17 -stable review
Cc: "Stephen Smalley" <sds@tycho.nsa.gov>, "Willy Tarreau" <w@1wt.eu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <Xine.LNX.4.64.0708220707390.9414@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070822083844.%N@1wt.eu>
	 <6bffcb0e0708220410u4ab3978eq18786ac186e88c7d@mail.gmail.com>
	 <Xine.LNX.4.64.0708220621550.28878@us.intercode.com.au>
	 <1187789765.1451.310.camel@moss-spartans.epoch.ncsc.mil>
	 <1187790174.1451.315.camel@moss-spartans.epoch.ncsc.mil>
	 <Xine.LNX.4.64.0708220707390.9414@us.intercode.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/07, James Morris <jmorris@namei.org> wrote:
> On Wed, 22 Aug 2007, Stephen Smalley wrote:
>
> > Oops, never mind - tail still follows secmark, so that shouldn't matter.
> > So I'm not sure why we are getting a bad value for secmark here - should
> > be initialized to zero and never modified unless there is an iptables
> > secmark rule.
>
> Michal, do you see this in current git?

No, I do not see this problem in 2.6.23. I had similar problem last
month, but it is fixed now.

http://lkml.org/lkml/2007/7/12/362

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
