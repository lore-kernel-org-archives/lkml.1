Return-Path: <linux-kernel-owner+w=401wt.eu-S933902AbXFFSk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933902AbXFFSk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758778AbXFFSkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:40:20 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:18611 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571AbXFFSkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:40:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=Re2KG/rGlDbhrCiqylgnM+RGzFoEy58mvYUT1tPP5f937ltO3sO9RigZePYTTD1g2bAMcMule4t8B8cAxPeljRVStnX1aOGKG2rq6VFFo6krySsEDbyOuQxJRyRemeOM68blam6dmbm0B9uq3ANSk13mJXdvOZ4dd10jbMWiWfo=
Date: Wed, 6 Jun 2007 14:40:16 -0400
To: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Size of kernel modules
Message-ID: <20070606184015.GB20615@nineveh.local>
Mail-Followup-To: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>,
	linux-kernel@vger.kernel.org
References: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 05:05:34PM +0200, Christoph Pleger wrote:
> I found out that the filenames are the same, but the size of the files
> differs very much. I found a module file in the new directory that was
> almost five times as large as the file with the same name in the old
> directory.

    For some reason I haven't looked into, copying the Ubuntu .config
file always results in having "Build the kernel with debug info"
set, which makes the resulting kernel huge.  Ubuntu's distributed
kernel binary certainly doesn't have this stuff built in, so turn it
off in the "Kernel Hacking" menu.

    If you find that your new kernel spews a lot of messages like "PM:
adding device nobus:yourmom", flip "Power Management Debugging" off
under the "Power management" menu also.  I wouldn't do this
preemptively, though -- it turns off other stuff too, and I think
Ubuntu's kernel is patched not to do that (and newer kernels have the
options separated, I think).

    Flipping the option and building a new package is pretty quick --
it doesn't rebuild much.
--
Joseph Fannin
jfannin@gmail.com || jhf@columbus.rr.com

