Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978Ab0AFQqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab0AFQqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 11:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914Ab0AFQqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 11:46:31 -0500
Received: from www84.your-server.de ([213.133.104.84]:57320 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab0AFQqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 11:46:31 -0500
Subject: [PATCH] checkpatch.pl: add union and struct to the exceptions list
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
       jschopp@austin.ibm.com, davej@redhat.com
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 06 Jan 2010 17:46:00 +0100
Message-ID: <1262796360.1011.9.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add the struct and union keywords to the exceptions list of
the checkpatch.pl script, to prevent error message "Macros with multiple
statements should be enclosed in a do - while loop". Otherwise it is not
possible to build a struct or union with a macro. 

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 checkpatch.pl |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.33-rc2.orig/scripts/checkpatch.pl	2009-12-03 04:51:21.000000000 +0100
+++ linux-2.6.33-rc2.new/scripts/checkpatch.pl	2010-01-06 17:35:29.747634447 +0100
@@ -2348,6 +2348,8 @@ sub process {
 				DECLARE_PER_CPU|
 				DEFINE_PER_CPU|
 				__typeof__\(|
+				union|
+				struct|
 				\.$Ident\s*=\s*|
 				^\"|\"$
 			}x;


