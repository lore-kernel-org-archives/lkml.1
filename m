Return-Path: <linux-kernel-owner+w=401wt.eu-S1759697AbYDKI75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759697AbYDKI75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758633AbYDKI7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:59:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758450AbYDKI7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:59:35 -0400
Subject: Re: [PATCH] xen: Enable Xen console by default in domU
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@pol.net, Jeremy Fitzhardinge <jeremy@goop.org>,
       mingo@redhat.com
In-Reply-To: <1207903945.26445.4.camel@muff>
References: <87hcehshyc.fsf@pike.pond.sub.org>
	 <87d4oxvhk0.fsf@pike.pond.sub.org>  <1207903945.26445.4.camel@muff>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 09:59:16 +0100
Message-Id: <1207904356.26445.8.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 09:52 +0100, Mark McLoughlin wrote:
> On Thu, 2008-04-10 at 17:46 +0200, Markus Armbruster wrote:
> > diff --git a/kernel/printk.c b/kernel/printk.c
> > index c46a20a..c07bfc1 100644
> > --- a/kernel/printk.c
> > +++ b/kernel/printk.c
> > @@ -118,6 +118,7 @@ struct console_cmdline
> >  static struct console_cmdline console_cmdline[MAX_CMDLINECONSOLES];
> >  static int selected_console = -1;
> >  static int preferred_console = -1;
> > +int console_set_on_cmdline;

You'd also need to export this symbol for the unusual case where fbfront
is a module ...

Cheers,
Mark.


