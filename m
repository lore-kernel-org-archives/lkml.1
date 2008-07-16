Return-Path: <linux-kernel-owner+w=401wt.eu-S1758431AbYGPK7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431AbYGPK7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 06:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYGPK67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 06:58:59 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:15903 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbYGPK66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 06:58:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XdcHqNZpeXEGmiVf3fpqofUTZmdddUjouloQyCNNq4Y+5ljYHy4nqnmono9zzXKFZ0
         4a23V+QJbqaDT1rZShc013pjn472pjpRLBwz+mAgkr0kEkm6LCIW8gy1Ss0HHcfudB5d
         4V7MSAs4qdfKiB3vIuPkSsV+uwJ5KePINoh4g=
Message-ID: <520f0cf10807160358t22fefd3fn70d50e59b394ab3b@mail.gmail.com>
Date: Wed, 16 Jul 2008 12:58:56 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Jan Engelhardt" <jengelh@medozas.de>
Subject: Re: Make the git URL match usage
Cc: "Bodo Eggert" <7eggert@gmx.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.1.10.0807161205220.26724@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <aQ9CN-4cK-11@gated-at.bofh.it>
	 <E1KJ3Ex-0001LD-Ub@be1.7eggert.dyndns.org>
	 <alpine.LNX.1.10.0807161205220.26724@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 12:06 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> On Wednesday 2008-07-16 10:54, Bodo Eggert wrote:
>
>>jkacur <jkacur@gmail.com> wrote:
>>
>>> Subject: Make the git URL match the usage
>>> Change the MAINTAINERS file so that the git URL reads EXACTLY the way someone
>>> would use it.
>>
>>> +++ linux-2.6.26/MAINTAINERS
>>
>>> +T:   git://git.kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
>>                            ^^
>
> There is more brokenness in this patch. That URL (even without ':')
> gives 404.
> Here is a clueful hint...
>
> -git://git.kernel.org/pub/scm/linux/kernel/ericvh/v9fs.git
> +git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git
>
> Check the URLs before modifying them.
>

Incidentally, although I am now committed to fixing all these
problems, note that since I merely mechanically converted
git kernel.org:
to
git://git.kernel.org/
The rest of the source tree location was already wrong BEFORE I
touched it, as well as inconsistent, so this is another indication
that this should be fixed.
