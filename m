Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbZKRWJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbZKRWJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757121AbZKRWJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:09:18 -0500
Received: from tundra.namei.org ([65.99.196.166]:37545 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756863AbZKRWJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:09:17 -0500
Date: Thu, 19 Nov 2009 09:09:20 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov
Subject: Re: [PATCH] selinux: Fix warnings
In-Reply-To: <20091118160459.GA3287@hack>
Message-ID: <alpine.LRH.2.00.0911190909030.22277@tundra.namei.org>
References: <20091118143951.4691.33970.stgit@localhost.localdomain> <20091118160459.GA3287@hack>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009, Am?rico Wang wrote:

> On Wed, Nov 18, 2009 at 02:39:51PM +0000, Alan Cox wrote:
> >scripts/selinux/genheaders/genheaders.c:20: warning: no previous prototype  
> >for ?usage?
> >scripts/selinux/genheaders/genheaders.c:26: warning: no previous prototype
> >for ?stoupperx?
> >
> >Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
> 

Thanks.


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

> >---
> >
> > scripts/selinux/genheaders/genheaders.c |    4 ++--
> > 1 files changed, 2 insertions(+), 2 deletions(-)
> >
> >
> >diff --git a/scripts/selinux/genheaders/genheaders.c b/scripts/selinux/genheaders/genheaders.c
> >index 3b16145..771b86f 100644
> >--- a/scripts/selinux/genheaders/genheaders.c
> >+++ b/scripts/selinux/genheaders/genheaders.c
> >@@ -17,13 +17,13 @@ struct security_class_mapping {
> > 
> > const char *progname;
> > 
> >-void usage(void)
> >+static void usage(void)
> > {
> > 	printf("usage: %s flask.h av_permissions.h\n", progname);
> > 	exit(1);
> > }
> > 
> >-char *stoupperx(const char *s)
> >+static char *stoupperx(const char *s)
> > {
> > 	char *s2 = strdup(s);
> > 	char *p;
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Live like a child, think like the god.
>  
> 

-- 
James Morris
<jmorris@namei.org>
