Return-Path: <linux-kernel-owner+w=401wt.eu-S1751837AbZJWV4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbZJWV4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 17:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbZJWV4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 17:56:34 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50333 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZJWV4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 17:56:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=tEODO72yeDG3BNpg3d4qv4TUGzSdFoKCpLgUEDT2FAuB6yPAQiBJrBpCmC6tagen+D
         F5GXPSmu8nVVe7ifu9mtsoelgcZnH9zGbEy40ErqfdAd4nalCzPztkULoWaxsrIgp5ZY
         kbfivIWcNIMbftAfXVK+ESzf4d+olNzHOBXtE=
MIME-Version: 1.0
In-Reply-To: <20091023210231.GC8356@elte.hu>
References: <1256330234-14079-1-git-send-email-marti@juffo.org> 
	<20091023210231.GC8356@elte.hu>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Fri, 23 Oct 2009 19:56:18 -0200
Message-ID: <193b0f820910231456o24bf95b6mf3e72f1b27870af5@mail.gmail.com>
Subject: Re: [PATCH] perf tools: add compatibility with libelf 0.8 and 
	autodetect
To: Ingo Molnar <mingo@elte.hu>
Cc: Marti Raudsepp <marti@juffo.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry, Ingo, forgot to reply-all)

On Fri, Oct 23, 2009 at 19:02, Ingo Molnar <mingo@elte.hu> wrote:
> Also, this would be an urgent fix for v2.6.32 too, to make perf build on
> Arch Linux, agreed?
>
If the fix is as simple as this patch, and will not cause any other
problems, may it be sent to -stable as well?


To make perf build on Arch is also possible to install elfutils from
AUR (http://aur.archlinux.org/packages.php?ID=5300) and I've made a
request some months ago to switch to this library instead of using
libelf but got no answers.

I think it's Arch's fault to continue using an unmaintained library
when there's an easy replacement, but if the "fix" is easy, why not?



Lucas De Marchi
