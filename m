Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbYG1W75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbYG1W75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYG1W7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:59:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbYG1W7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:59:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Pavel Emelyanov <xemul@openvz.org>
cc: dhowells@redhat.com, jmorris@redhat.com, linux-kernel@vger.kernel.org
Subject: Request for documentation of PID handling functions
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Mon, 28 Jul 2008 23:59:46 +0100
Message-ID: <21590.1217285986@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Pavel,

Can you please provide documentation for the PID handling functions you
supplied in commit:

	7af5729474b5b8ad385adadab78d6e723e7655a3

In particular I'd like to know what locks are required when.  I'm trying to
determine if in this piece of code:

		read_lock(&tasklist_lock);
		ret = 0;
		if (pid != task_pid_vnr(current))
			ret = -EPERM;
		read_unlock(&tasklist_lock);

the lock of tasklist_lock is necessary.

David
