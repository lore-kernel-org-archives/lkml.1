Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbZKRQE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbZKRQE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757496AbZKRQE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:04:28 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:43411 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378AbZKRQE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:04:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=d/vnsKfAG+zhLvx0e8FcWYD/YsYDYKFdox/Thy+5CH7s3LAaMeAXCE+96LLDx63q9K
         v7+1NhuWxDY3PZXXsre1SSe+9yUtwvZbi2q7iyzIbLzZ8hSpB/wQe8yuyHWGCa+jh3dG
         7TuEigyc6kVXJFegS7LDiy3iYs2q/BcPkUgdg=
Date: Thu, 19 Nov 2009 00:04:59 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selinux: Fix warnings
Message-ID: <20091118160459.GA3287@hack>
References: <20091118143951.4691.33970.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091118143951.4691.33970.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 02:39:51PM +0000, Alan Cox wrote:
>scripts/selinux/genheaders/genheaders.c:20: warning: no previous prototype  
>for ‘usage’
>scripts/selinux/genheaders/genheaders.c:26: warning: no previous prototype
>for ‘stoupperx’
>
>Signed-off-by: Alan Cox <alan@linux.intel.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

>---
>
> scripts/selinux/genheaders/genheaders.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>
>diff --git a/scripts/selinux/genheaders/genheaders.c b/scripts/selinux/genheaders/genheaders.c
>index 3b16145..771b86f 100644
>--- a/scripts/selinux/genheaders/genheaders.c
>+++ b/scripts/selinux/genheaders/genheaders.c
>@@ -17,13 +17,13 @@ struct security_class_mapping {
> 
> const char *progname;
> 
>-void usage(void)
>+static void usage(void)
> {
> 	printf("usage: %s flask.h av_permissions.h\n", progname);
> 	exit(1);
> }
> 
>-char *stoupperx(const char *s)
>+static char *stoupperx(const char *s)
> {
> 	char *s2 = strdup(s);
> 	char *p;
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
