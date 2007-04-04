Return-Path: <linux-kernel-owner+w=401wt.eu-S1752274AbXDDLbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbXDDLbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 07:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXDDLbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 07:31:15 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:48581 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbXDDLbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 07:31:15 -0400
Message-ID: <46138C36.2070907@gmail.com>
Date: Wed, 04 Apr 2007 13:29:58 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
References: <46138B4C.2050409@gmail.com>
In-Reply-To: <46138B4C.2050409@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020604030504090605040106"
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020604030504090605040106
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 04/04/2007 01:26 PM, Rene Herman wrote:

> Can we have a MODULE_MAINTAINER to complement MODULE_AUTHOR?

And here's the accompanying patch to the module-init-tools-3.3-pre1 as 
found on http://kernel.org/pub/linux/utils/kernel/module-init-tools/

Rene.

--------------020604030504090605040106
Content-Type: text/plain;
 name="modinfo_maintainer.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="modinfo_maintainer.diff"

--- module-init-tools-3.3-pre1/modinfo.c.orig	2007-04-04 12:54:19.000000000 +0200
+++ module-init-tools-3.3-pre1/modinfo.c	2007-04-04 12:59:42.000000000 +0200
@@ -213,6 +213,7 @@
 static struct option options[] =
 {
 	{"author", 0, 0, 'a'},
+	{"maintainer", 0, 0, 'm'},
 	{"description", 0, 0, 'd'},
 	{"license", 0, 0, 'l'},
 	{"parameters", 0, 0, 'p'},
@@ -347,9 +348,10 @@
 	else
 		abort();
 
-	while ((opt = getopt_long(argc,argv,"adlpVhn0F:",options,NULL)) >= 0){
+	while ((opt = getopt_long(argc,argv,"amdlpVhn0F:",options,NULL)) >= 0){
 		switch (opt) {
 		case 'a': field = "author"; break;
+		case 'm': field = "maintainer"; break;	  
 		case 'd': field = "description"; break;
 		case 'l': field = "license"; break;
 		case 'p': field = "parm"; break;

--------------020604030504090605040106--
