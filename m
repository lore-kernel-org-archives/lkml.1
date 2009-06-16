Return-Path: <linux-kernel-owner+w=401wt.eu-S1759130AbZFPO3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130AbZFPO3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZFPO3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:29:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48120 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbZFPO3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:29:38 -0400
Message-ID: <4A37AC54.2000607@redhat.com>
Date: Tue, 16 Jun 2009 10:29:40 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] scripts: allow docproc invocation from external
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch appears to be adversely affect the documentation build in the kernel
source directory. When trying "make htmldocs" in the source directory of the
kernel this git commit causes the make to fail with:

$ make htmldocs V=1make -f scripts/Makefile.build obj=scripts/basic
make -f scripts/Makefile.build obj=Documentation/DocBook htmldocs
  SRCTREE=/home/wcohen/kernel/mingo/linux.trees.git/
/home/wcohen/kernel/mingo/linux.trees.git/scripts/basic/docproc doc
Documentation/DocBook/alsa-driver-api.tmpl
> >Documentation/DocBook/alsa-driver-api.xml
exec /scripts/kernel-doc: No such file or directory
exec /scripts/kernel-doc: No such file or directory
...

-Will

