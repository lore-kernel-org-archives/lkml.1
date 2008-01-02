Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbYABXMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbYABXMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 18:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbYABXMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 18:12:41 -0500
Received: from ozlabs.org ([203.10.76.45]:49891 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbYABXMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 18:12:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] depmod: sort output according to modules.order, take #2
Date: Thu, 3 Jan 2008 10:12:21 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       kay.sievers@vrfy.org, Greg KH <greg@kroah.com>,
       Jon Masters <jonathan@jonmasters.org>
References: <475936CE.70703@gmail.com> <475BB5AE.40503@gmail.com> <477B71F0.8020706@gmail.com>
In-Reply-To: <477B71F0.8020706@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_WpBfHtCxtvg9kpA"
Message-Id: <200801031012.22776.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_WpBfHtCxtvg9kpA
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 02 January 2008 22:13:52 Tejun Heo wrote:
> Tejun Heo wrote:
> > Tejun Heo wrote:
> >> Kbuild now generates and installs modules.order along with modules.
> >> This patch updates depmod such that it sorts module list according to
> >> the file before generating output files.  Modules which aren't on
> >> modules.order are put after modules which are ordered by
> >> modules.order.
> >>
> >> This makes modprobe to prioritize modules according to kernel
> >> Makefile's just as built-in modules are link-ordered by them.
> >>
> > The kernel part is in now.  Rusty Russell, what do you think about this
> > depmod change?
>
> Ping?

Oh, sorry.  Jon is now module-init-tools maintainer, and I've cc'd him and 
forwarded your original patch.

Thanks,
Rusty.




--Boundary-00=_WpBfHtCxtvg9kpA
Content-Type: message/rfc822;
  name="forwarded message"
Content-Transfer-Encoding: 7bit
Content-Description: Tejun Heo <htejun@gmail.com>: [PATCH] depmod: sort output according to modules.order, take #2
Content-Disposition: inline

Return-Path: <htejun@gmail.com>
X-Spam-Checker-Version: SpamAssassin 3.2.1 (2007-05-02) on ozlabs.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,SPF_PASS
	autolearn=ham version=3.2.1
X-Original-To: rusty@rustcorp.com.au
Delivered-To: rusty@ozlabs.org
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.182])
	by ozlabs.org (Postfix) with ESMTP id 69A1FDDE06
	for <rusty@rustcorp.com.au>; Fri,  7 Dec 2007 23:08:15 +1100 (EST)
Received: by wa-out-1112.google.com with SMTP id m38so1568968waf
        for <rusty@rustcorp.com.au>; Fri, 07 Dec 2007 04:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:received:received:received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        bh=XS0uJbuxxlAnA0Yk58/XF7khPkqylBzo2VbhfNC8ugQ=;
        b=eMUWfjBVu4xHtcAvWBKs/F2+GvYvAWgZHOvbBn0IzX0bbdpTG+4CxYjbob9hheaPPpxwJ8v1GtzASNzdRB4r1qP6f0A7bKKQOF70JyM6r2Q3c3iOTq2kYxXCCCLrZZpJXpdJH7YFCSpmAur9cANYCu5zcTwvV2iEEIPf0HCTu+s=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=dE5LU9mXG5NlSc9OZ1Yb/qPnYtnlDLl8CM1IbLNEPdYrspbka2nFenr21dCmvFwD/FN1q1qX5s6kuUmSS62BoZyLOzQro2zt9g/naeeZAfCXmKqb/lpa9W7Pb+x7IQzoT5ZcgYkidMmVtIO7dvbMKbMXwf2DaYx2dAofVbx4L9Y=
Received: by 10.114.195.19 with SMTP id s19mr3048310waf.1197029294088;
        Fri, 07 Dec 2007 04:08:14 -0800 (PST)
Received: from htj.dyndns.org ( [222.235.223.226])
        by mx.google.com with ESMTPS id k39sm1043072wah.2007.12.07.04.08.06
        (version=TLSv1/SSLv3 cipher=OTHER);
        Fri, 07 Dec 2007 04:08:12 -0800 (PST)
Received: from [127.0.0.2] (htj.dyndns.org [127.0.0.2])
	by htj.dyndns.org (Postfix) with ESMTP id E4A2113A81B1;
	Fri,  7 Dec 2007 21:07:57 +0900 (KST)
Message-ID: <4759379D.8090201@gmail.com>
Date: Fri, 07 Dec 2007 21:07:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>,
 Linux Kernel <linux-kernel@vger.kernel.org>,
 notting@redhat.com,
 rusty@rustcorp.com.au,
 kay.sievers@vrfy.org,
 Greg KH <greg@kroah.com>
Subject: [PATCH] depmod: sort output according to modules.order, take #2
References: <475936CE.70703@gmail.com>
In-Reply-To: <475936CE.70703@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain;
  charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Bogosity: Unsure, tests=bogofilter, spamicity=0.520000, version=1.1.5
X-UID: 

Kbuild now generates and installs modules.order along with modules.
This patch updates depmod such that it sorts module list according to
the file before generating output files.  Modules which aren't on
modules.order are put after modules which are ordered by
modules.order.

This makes modprobe to prioritize modules according to kernel
Makefile's just as built-in modules are link-ordered by them.

This patch is against module-init-tools 3.3-pre1.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Bill Nottingham <notting@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
Comment added and path comparion logic slightly modified such that
dirname part of mode->pathname is ignored instead of prepending
dirname to lines read from modules.order.  Behavior-wise it's
identical to the previous version.

Thanks.

 depmod.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/depmod.c b/depmod.c
index ea7ad05..c3ae5a2 100644
--- a/depmod.c
+++ b/depmod.c
@@ -585,6 +585,54 @@ static struct module *grab_basedir(const char *dirname)
 	return list;
 }
 
+static void sort_modules(const char *dirname, struct module **listp)
+{
+	struct module *list = *listp, *tlist = NULL, **tpos = &tlist;
+	FILE *modorder;
+	int dir_len = strlen(dirname) + 1;
+	char file_name[dir_len + strlen("modules.order") + 1];
+	char line[10240];
+
+	sprintf(file_name, "%s/%s", dirname, "modules.order");
+
+	modorder = fopen(file_name, "r");
+	if (!modorder) {
+		/* Older kernels don't generate modules.order.  Just
+		   return if the file doesn't exist. */
+		if (errno == ENOENT)
+			return;
+		fatal("Could not open '%s': %s\n", file_name, strerror(errno));
+	}
+
+	sprintf(line, "%s/", dirname);
+
+	/* move modules listed in modorder file to tlist in order */
+	while (fgets(line, sizeof(line), modorder)) {
+		struct module **pos, *mod;
+		int len = strlen(line);
+
+		if (line[len - 1] == '\n')
+			line[len - 1] = '\0';
+
+		for (pos = &list; (mod = *pos); pos = &(*pos)->next) {
+			if (strcmp(line, mod->pathname + dir_len) == 0) {
+				*pos = mod->next;
+				mod->next = NULL;
+				*tpos = mod;
+				tpos = &mod->next;
+				break;
+			}
+		}
+	}
+
+	/* append the rest */
+	*tpos = list;
+
+	fclose(modorder);
+
+	*listp = tlist;
+}
+
 static void parse_modules(struct module *list)
 {
 	struct module *i;
@@ -857,6 +905,7 @@ int main(int argc, char *argv[])
 	} else {
 		list = grab_basedir(dirname);
 	}
+	sort_modules(dirname, &list);
 	parse_modules(list);
 
 	for (i = 0; i < sizeof(depfiles)/sizeof(depfiles[0]); i++) {

--Boundary-00=_WpBfHtCxtvg9kpA--
