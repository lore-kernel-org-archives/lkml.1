Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbYB0TB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbYB0TB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbYB0TBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:01:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:41732 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbYB0TBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:01:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=BeKUWnAFQRt7dGjgHoK5u5B7oBz5MDntJmoi71EqXy5ya1OqyHNY0C07vIfFRUwwTUfhz4+4JHoLGA3VHYe+ZyuD5OZ1yEd8/CPqf+b2ID5xpZDuIF/15GwHO/bcZFRegaiHwmQqBIKZCeeQmuSS0zgFd1pPo7lhUgneXlnJTjU=
Date: Wed, 27 Feb 2008 22:01:16 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Richard Henderson <rth@twiddle.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] alpha: vmlinux.lds cleanup - use THREAD_SIZE macro
Message-ID: <20080227190116.GB8352@cvg>
References: <20080226195159.GC6748@cvg> <20080227185756.GA12569@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227185756.GA12569@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Wed, Feb 27, 2008 at 07:57:56PM +0100]
| On Tue, Feb 26, 2008 at 10:51:59PM +0300, Cyrill Gorcunov wrote:
| > This patch modifies thread_info.h header to be able to include it
| > into linker script and then we're able to use THREAD_SIZE in
| > vmlinux.lds
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
| 
| And I also build tested the patch and checked the
| resulting .lds files.
| And they were semantically equal.
| 
| 	Sam
| 

Thanks Sam, I'm almost complete with series on other archs.
Will send them soon (but maybe not today ;)

		- Cyrill -
