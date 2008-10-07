Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbYJGLIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbYJGLIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYJGLIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:08:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58121 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbYJGLIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:08:04 -0400
Date: Tue, 7 Oct 2008 13:14:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH] Add kerneldoc documentation for new printk format extensions
Message-ID: <20081007111410.GF20740@one.firstfloor.org>
References: <20081007101532.GA25565@basil.nowhere.org> <20081007103305.GH2886@hack.voiplan.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081007103305.GH2886@hack.voiplan.pt>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 11:33:05AM +0100, Américo Wang wrote:
> On Tue, Oct 07, 2008 at 12:15:32PM +0200, Andi Kleen wrote:
> >Add documentation in kerneldoc for new printk format extensions
> >
> >This patch documents the new %pS/%pF options in printk in kernel doc.
> >
> >Hope I didn't miss any other extension.
> >
> >Signed-off-by: Andi Kleen <ak@linux.intel.com>
> >
> >Index: linux-2.6.27-rc6-misc/kernel/printk.c
> >===================================================================
> >--- linux-2.6.27-rc6-misc.orig/kernel/printk.c
> >+++ linux-2.6.27-rc6-misc/kernel/printk.c
> >@@ -593,6 +593,8 @@ static int have_callable_console(void)
> >  *
> >  * See also:
> >  * printf(3)
> >+ *
> >+ * See the vsnprintf() documentation for format string extensions over C99.
> >  */
> > 
> > asmlinkage int printk(const char *fmt, ...)
> >Index: linux-2.6.27-rc6-misc/lib/vsprintf.c
> >===================================================================
> >--- linux-2.6.27-rc6-misc.orig/lib/vsprintf.c
> >+++ linux-2.6.27-rc6-misc/lib/vsprintf.c
> >@@ -565,6 +565,10 @@ static char *pointer(const char *fmt, ch
> >  * @fmt: The format string to use
> >  * @args: Arguments for the format string
> >  *
> >+ * This function follows C99 vsnprintf, but has some extensions:
> >+ * %pS output the name of a text symbol
> >+ * %pF output the name of a function pointer
> 
> s/output/outputs/ ? :)

It's not complete sentences but a list of options, so no.

bla do this
blub do that

-Andi

-- 
ak@linux.intel.com
