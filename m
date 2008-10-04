Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYJDViQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYJDViQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 17:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYJDViA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 17:38:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:19754 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbYJDViA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 17:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=riJNY8Itq+E1lm96n2fB029hLR+4UNNj+iFWJdKlkJmDbJkdG/caK0mKMZqvnwwA6q
         jJM656sxNx+CrkRWR5PobXPRkUtQvJ/1Xtn7E2M/5hYAwe4sn3EVm2OYTgPTAdZduhJ4
         HIwzzDUiEiGy9eR7tYUuatVoiMt58N1dgrLQE=
Date: Sun, 5 Oct 2008 01:40:34 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: add "personality" to process status file
Message-ID: <20081004214034.GA13129@x200.localdomain>
References: <20081002211424.GJ10632@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002211424.GJ10632@outflux.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 02:14:24PM -0700, Kees Cook wrote:
> There is no sane way to query the personality flags of arbitrary process
> from userspace.  This adds the flags to the /proc/$pid/status file.
> For example, to detect READ_IMPLIES_EXEC:
> 
> $ ./32bit-sleeper &
> [1] 6732
> $ grep ^Pers /proc/6732/status
> Personality:    00000000
> $ execstack -s 32bit-sleeper
> $ ./32bit-slepper &
> [2] 6735
> $ grep ^Pers /proc/6735/status
> Personality:    00040000

Applied to proc.git without unrelated sched.h commentary :-)
