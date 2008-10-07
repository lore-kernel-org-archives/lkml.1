Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbYJGKdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbYJGKdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYJGKd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:33:26 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:42854 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbYJGKdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:33:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cU9TU0f8UejoXJmvzdGgbYtjAwwtoUjJ016xsuf4MuYoTuT3dc/cegmEbL5aRmsF4/
         ywWsTCH8IZVWuGpi7kAouHAeqKId72djYPFVKe/7/y6cdv4CFsi5EvSB8oU/ukbjE9Hu
         PG6y83MmBmeF4CgjszVBMD7kHc5sJoVXjaBGY=
Date: Tue, 7 Oct 2008 11:33:05 +0100
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] Add kerneldoc documentation for new printk format
	extensions
Message-ID: <20081007103305.GH2886@hack.voiplan.pt>
References: <20081007101532.GA25565@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007101532.GA25565@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 12:15:32PM +0200, Andi Kleen wrote:
>Add documentation in kerneldoc for new printk format extensions
>
>This patch documents the new %pS/%pF options in printk in kernel doc.
>
>Hope I didn't miss any other extension.
>
>Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
>Index: linux-2.6.27-rc6-misc/kernel/printk.c
>===================================================================
>--- linux-2.6.27-rc6-misc.orig/kernel/printk.c
>+++ linux-2.6.27-rc6-misc/kernel/printk.c
>@@ -593,6 +593,8 @@ static int have_callable_console(void)
>  *
>  * See also:
>  * printf(3)
>+ *
>+ * See the vsnprintf() documentation for format string extensions over C99.
>  */
> 
> asmlinkage int printk(const char *fmt, ...)
>Index: linux-2.6.27-rc6-misc/lib/vsprintf.c
>===================================================================
>--- linux-2.6.27-rc6-misc.orig/lib/vsprintf.c
>+++ linux-2.6.27-rc6-misc/lib/vsprintf.c
>@@ -565,6 +565,10 @@ static char *pointer(const char *fmt, ch
>  * @fmt: The format string to use
>  * @args: Arguments for the format string
>  *
>+ * This function follows C99 vsnprintf, but has some extensions:
>+ * %pS output the name of a text symbol
>+ * %pF output the name of a function pointer

s/output/outputs/ ? :)


-- 
"Sometimes the only way to stay sane is to go a little crazy."

