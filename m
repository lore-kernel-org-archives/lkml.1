Return-Path: <linux-kernel-owner+w=401wt.eu-S1762341AbYBVMCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762341AbYBVMCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYBVMCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:02:45 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:5382 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYBVMCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:02:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=QAeCJVOuI0Z9U3tmz9WQGoTGGxuqGihDV9wqb3AnRa9dTHI0JbnaCC6WCIc3TcBDx9YDNAFt/M4CycoYCA7OW1Y/Q4Zy1StFDwc4h/F0dd18bIfvr99Od++TuSA9sGJZwCwGltXoOeRuQYe59XSrGd9AAJ4Nkx67voJuuHv/Gbc=
Date: Fri, 22 Feb 2008 15:02:33 +0300
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tags: add menuconfig symbols as well
Message-ID: <20080222120233.GA2262@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steps to reproduce:

	vi -t NETFILTER

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1396,7 +1396,7 @@ define xtags
 	    $(all-kconfigs) | xargs $1 -a \
 		--langdef=kconfig \
 		--language-force=kconfig \
-		--regex-kconfig='/^[[:blank:]]*config[[:blank:]]+([[:alnum:]_]+)/\1/'; \
+		--regex-kconfig='/^[[:blank:]]*(menu|)config[[:blank:]]+([[:alnum:]_]+)/\2/'; \
 	    $(all-defconfigs) | xargs -r $1 -a \
 		--langdef=dotconfig \
 		--language-force=dotconfig \
@@ -1404,7 +1404,7 @@ define xtags
 	elif $1 --version 2>&1 | grep -iq emacs; then \
 	    $(all-sources) | xargs $1 -a; \
 	    $(all-kconfigs) | xargs $1 -a \
-		--regex='/^[ \t]*config[ \t]+\([a-zA-Z0-9_]+\)/\1/'; \
+		--regex='/^[ \t]*(menu|)config[ \t]+\([a-zA-Z0-9_]+\)/\2/'; \
 	    $(all-defconfigs) | xargs -r $1 -a \
 		--regex='/^#?[ \t]?\(CONFIG_[a-zA-Z0-9_]+\)/\1/'; \
 	else \
