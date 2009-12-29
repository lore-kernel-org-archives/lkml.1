Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbZL2Fz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbZL2Fz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 00:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZL2FzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 00:55:25 -0500
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:51092 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZL2FzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 00:55:25 -0500
From: hooanon05@yahoo.co.jp
To: viro@ZenIV.linux.org.uk
cc: linux-kernel@vger.kernel.org
Subject: Q. d_alloc() in pipe(2)
Date: Tue, 29 Dec 2009 14:55:20 +0900
Message-ID: <20021.1262066120@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In pipe(2), create_write_pipe() creates a dentry by
	struct qstr name = { .name = "" };
	d_alloc(root, &name);

But d_alloc() refers name->len which is uninitialized.
Isn't it better to replace d_alloc() by d_alloc_name(root, "")?


J. R. Okajima
