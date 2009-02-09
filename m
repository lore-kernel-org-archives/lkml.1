Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbZBIGPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbZBIGPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 01:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbZBIGPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 01:15:36 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:46221 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZBIGPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 01:15:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=m3VGDw1RZq8Q7cPy3uEGhRiMvCfe3sYFXuIQEtFYEbfoDahDlOq2oh2zd5vQAJfOv6
         BXzxzCTtUMDdu+u384PgdW2wNXt+OJso0ubgUY3jQjXTKsoC+OHM+AKl1m9jEov15GFa
         GxAohrlBUYHeQZMiABtHgo4dQixQpzJShlFJk=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: mingo@elte.hu
Cc: fweisbec@gmail.com, penberg@cs.helsinki.fi, rostedt@goodmis.org,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] splice patches for ftrace
Date: Mon,  9 Feb 2009 08:15:54 +0200
Message-Id: <cover.1234159200.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This implements splice support so we can use it in kmemtrace-user. Please
check it out and tell me what you think.

The "RFC" in the subject reads like "I tested this the best I could,
although kmemtrace-user isn't still ready.". As we speak, I'm working on
making kmemtrace over ftrace and kmemtrace-user work together nicely.


	Cheers,
	Eduard

Eduard - Gabriel Munteanu (2):
  trace: Move pipe waiting code out of tracing_read_pipe().
  trace: splice support for tracing_pipe

 kernel/trace/trace.c |  205 +++++++++++++++++++++++++++++++++++++++++++-------
 kernel/trace/trace.h |    6 ++
 2 files changed, 182 insertions(+), 29 deletions(-)

