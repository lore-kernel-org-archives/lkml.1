Return-Path: <linux-kernel-owner+w=401wt.eu-S1759582AbZBDXvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582AbZBDXvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759386AbZBDXte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:49:34 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:17556 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759357AbZBDXtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:49:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=T9jRvCC0PiFkUcT1D7dIMkxD4s2WLWtnqmEiepcjaDrWXOzUCnR+nWD4/knO60tfBG
         SB0tw3zFxYsXdtLCC1CPfS9UHmqEZLHZTUPkxarn6eNtWqvEtxiMPYArD6ULlbjzimqm
         wIAJgRDLhhYuu8A5RvCYPBvYwxf2FUSSYZyBE=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <a36005b50902041545qb9ce459y710bb3b9b8949b17@mail.gmail.com>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>
	 <20090204150507.665b5b7c.akpm@linux-foundation.org>
	 <a36005b50902041545qb9ce459y710bb3b9b8949b17@mail.gmail.com>
Date: Thu, 5 Feb 2009 12:49:31 +1300
Message-ID: <cfd18e0f0902041549t393c76d0s635b5e8c17fee2d1@mail.gmail.com>
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 12:45 PM, Ulrich Drepper <drepper@gmail.com> wrote:
> On Wed, Feb 4, 2009 at 3:05 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> How would you recommend that userspace determine whether its kernel
>> supports this feature, bearing in mind that someone might backport this
>> patch into arbitrarily earlier kernel versions?
>
>   fd = eventfd2 (CNT, EFD_SEMAPHORE);
>   if (fd == -1 && errno == EINVAL)
>     puts("cannot handled EFD_SEMAPHORE");

Crossed mails.  Ulrich put the point more succinctly.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
