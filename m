Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbZA3HbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbZA3HbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 02:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZA3HbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 02:31:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58141 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbZA3HbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 02:31:03 -0500
Subject: [RT] flags_extend in task_struct
From: Jon Masters <jcm@redhat.com>
To: williams <williams@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Fri, 30 Jan 2009 02:30:49 -0500
Message-Id: <1233300649.3937.103.camel@perihelion.bos.jonmasters.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

Do we really want a "flags_extend" in task_struct? If we're out of space
for new flags (which we are), is something else planned? Maybe a union?
I am curious because I'm reworking a patchset at the moment that adds
this.

Jon.


