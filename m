Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYLBBqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYLBBqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 20:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYLBBql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 20:46:41 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:53613 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbYLBBqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 20:46:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=nlmJgXlWTLu45KFLEJsZIyBc8/hzjLYY8h2ndDyq9sWV1oGQqgM7eBxRt2CAUZgIHi
         XDxbfFNDEB4712r17DS1OLUVPZ0/eXtjbu/O0Yh8cayiTS+JvM31BCyKvgmPrGQKYZL0
         wnJJzZ7CeV/dIaKxk3KUYKVC08XfVgHBnnRao=
Subject: ERROR 'syntax error' at token 'typeattribute'
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: SE Linux <selinux@tycho.nsa.gov>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 17:46:36 -0800
Message-Id: <1228182396.4021.7.camel@unix>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After spending a few days trying
to load the latest refpolicy,I decided to
do a git-pull, so after loading everything
seems pretty good, except I now receive a 
syntax error when compiling the refpolicy

policy/modules/apps/yam.te":11:ERROR 'syntax error' at token
'typeattribute' on line 2615741:
#line 11
        typeattribute yam_t application_domain_type;
checkpolicy:  error(s) encountered while parsing configuration
make: *** [policy.23] Error 1

this error comes from the latest svn,
nothing like this all day, just after git-pull.
If I use the stable tar ball no issues.

the latest pull is 2.6.28-rc6-00209-g6a12141


-- 
Justin P. Mattock <justinmattock@gmail.com>

