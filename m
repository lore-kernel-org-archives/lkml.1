Return-Path: <linux-kernel-owner+w=401wt.eu-S1760366AbZB0XqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366AbZB0XqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 18:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbZB0Xp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 18:45:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753194AbZB0Xp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 18:45:58 -0500
Date: Fri, 27 Feb 2009 15:45:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, felipe.balbi@nokia.com
Subject: Re: mmotm 2009-02-27-13-54 uploaded (input/misc/twl4030)
Message-Id: <20090227154516.10885514.akpm@linux-foundation.org>
In-Reply-To: <49A878BE.4080308@oracle.com>
References: <200902272212.n1RMClcN007585@imap1.linux-foundation.org>
	<49A878BE.4080308@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 15:35:26 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-02-27-13-54 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> 
> 
> mmotm-2009-0227-1354/drivers/input/misc/twl4030-pwrbutton.c:107: error: 'TWL4030_PWRIRQ_PWRBTN' undeclared (first use in this function)
> 

this, I guess:

--- a/drivers/input/misc/twl4030-pwrbutton.c~input-misc-add-twl4030-pwrbutton-driver-fix
+++ a/drivers/input/misc/twl4030-pwrbutton.c
@@ -104,7 +104,7 @@ static int __devinit twl4030_pwrbutton_p
 free_input_dev:
 	input_free_device(powerbutton_dev);
 free_irq_and_out:
-	free_irq(TWL4030_PWRIRQ_PWRBTN, NULL);
+	free_irq(irq, NULL);
 out:
 	return err;
 }
_

