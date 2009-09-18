Return-Path: <linux-kernel-owner+w=401wt.eu-S1751866AbZIRGC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbZIRGC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZIRGCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:02:55 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:59159 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZIRGCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:02:54 -0400
X-Greylist: delayed 1214 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2009 02:02:54 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T1IzyZzwKwkscoxnOq0nGCMzi8G/Wwc4nrYNN7+TUeph2cViBdvvFgyZBwzrVAEuoK
         Yi4pHBe+K6grQKxuA6dEnQDHKvFVF+3b70Zg5COXWnaZFDFfRBl8/gVRtx9Ca58F43Q7
         cPMJiIC2q0sa446ajB/MjK815Iw4autFZqoU0=
Date: Thu, 17 Sep 2009 23:02:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: input-current tree build failure
Message-ID: <20090918060252.GD18668@core.coreip.homeip.net>
References: <20090917111228.800851b0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917111228.800851b0.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Sep 17, 2009 at 11:12:28AM +1000, Stephen Rothwell wrote:
> Hi Dmitry,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> In file included from drivers/input/serio/i8042.c:23:
> include/linux/i8042.h: In function 'i8042_check_port_owner':
> include/linux/i8042.h:58: error: parameter name omitted
> drivers/input/serio/i8042.c: At top level:
> drivers/input/serio/i8042.c:130: error: redefinition of 'i8042_lock_chip'
> include/linux/i8042.h:45: note: previous definition of 'i8042_lock_chip' was here
> drivers/input/serio/i8042.c:136: error: redefinition of 'i8042_unlock_chip'
> include/linux/i8042.h:49: note: previous definition of 'i8042_unlock_chip' was here
> drivers/input/serio/i8042.c:246: error: redefinition of 'i8042_command'
> include/linux/i8042.h:53: note: previous definition of 'i8042_command' was here
> drivers/input/serio/i8042.c:1193: error: redefinition of 'i8042_check_port_owner'
> include/linux/i8042.h:58: note: previous definition of 'i8042_check_port_owner' was here
> 
> Caused by commit 1f57f19e6245c5534c3518a8455419461ec06778 ("Input: libps2
> - additional locking for i8042 ports").
> 
> Please, if you add code that depends on a CONFIG option, build it with
> and without the options set ...
> 

I did ;) ... but not as module, sorry about this, will fix in a moment.

-- 
Dmitry
