Return-Path: <linux-kernel-owner+w=401wt.eu-S935591AbXHOT0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935591AbXHOT0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 15:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758500AbXHOT0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 15:26:09 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:57168 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758712AbXHOT0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 15:26:08 -0400
Date: Wed, 15 Aug 2007 15:26:07 -0400
To: Marc Perkel <mperkel@yahoo.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Thinking outside the box on file systems
Message-ID: <20070815192607.GE9410@csclub.uwaterloo.ca>
References: <F38DAAD2-D984-4704-94AC-5FB963C4373C@mac.com> <631385.29200.qm@web52512.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <631385.29200.qm@web52512.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 10:59:12AM -0700, Marc Perkel wrote:
> When one thinks outside the box one has to think about
> evolving beyond what you are used to. When I moved
> beyond DOS I have to give up the idea of 8.3 file
> names. The idea here is to come up with a model that
> can emulate the existing system for backwards
> compatibility.

But moving beyond 8.3 didn't prevent you from still using 8.3 names if
you wanted too.  Longer file names are just an extension of shorter
ones.

> The concept behind my model is to create a new layer
> where you can do ANYTHING with file names and
> permissions and create models that emulate Linux, DOS,
> Windows, Mac, or anything else you can dream of. Then
> you can create a Linux/Windows/Mac template to emulate
> what you are used to.

I am not even sure your idea could represent everything that is
currently possible with Posix ACLs and the standard unix permisions,
never mind SELinux.  I am also almost entirely convinced that your idea
would be amazingly slow and inefficient and a serious pain to use.  And
of course nothing seems to ever suceed without backwards compatibility
to support legacy programs until new ones take over, unless it is in
fact an entirely new concept for a new field and isn't trying to replace
some existing working system.

--
Len Sorensen
