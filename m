Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbYBQTIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbYBQTIj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYBQTIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:08:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:25199 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbYBQTIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:08:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=SVyHjtvrJrFzjEoXYR4F2JL3DIaCkrib3VlasN+1XM9GYahpD/X59PxfOeON9kh2jk8mo+BZ3YWQjVs4RgLVV94BGOuVQjFy7xm/LDqyGOlYZve2lMHAT82+A9KULxjw38XhxkbJWt2fNVUBMwuE/2igWDPDq6gp/XdwBEwbuWc=
Date: Sun, 17 Feb 2008 22:08:01 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: ak@suse.de, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86: lds - Use THREAD_SIZE instead of numeric
	constant
Message-ID: <20080217190801.GC31968@cvg>
References: <20080217151716.274134094@gmail.com> <20080217151925.402628615@gmail.com> <20080217185936.GB14588@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217185936.GB14588@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Sun, Feb 17, 2008 at 07:59:36PM +0100]
| On Sun, Feb 17, 2008 at 06:17:18PM +0300, Cyrill Gorcunov wrote:
| > Though we use PDA for regular task stack but that
| > is not acceptable for init_task wich is special
| > one. We still have to allocate init_task's stack
| > in that manner.
| 
| hpa had some comments about this particular alignment.
| If we keep the alignmnet then Cyrill's patch looks good.
| 
| But maybe we should check what is the real alignmment
| requirement (outside the scope of wha you do - someone
| more intiminate with this coide should do it).
| 
| 	Sam
| 

Yes Sam, I've read Peter and Ingo comments on this patch
(actually I sent the same patch maybe week ago and Peter
and Ingo told me that we use %fs,%gs now for stack) but
as I pointed in comment - this alignment is still using
by Xen and lguest and even x86. So - it would be really
usefull for me if someone give me the last point - YES we
use such an alignment for stack, NO - we don't use it at all.
I was trying to hadle this myself - but I'm not a specialist
in this area you know ;)

		- Cyrill -
