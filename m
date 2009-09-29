Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZI2SPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZI2SPC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:15:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZI2SPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:15:01 -0400
Received: from mail.perches.com ([173.55.12.10]:1420 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbZI2SPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:15:00 -0400
Subject: [RFC] move #define pr_fmt KBUILD_MODNAME and KMSG_COMPONENT to
 Makefiles?
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Sep 2009 11:15:04 -0700
Message-Id: <1254248104.28232.447.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are starting to be more uses of

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

and

#define KMSG_COMPONENT "foo"
#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt

in kernel sources.

Perhaps it would be better to put these
defines in the appropriate Makefile and not
sprinkle the sources with them multiple times?



