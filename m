Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbZBWLA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbZBWLA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 06:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZBWLAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 06:00:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46931 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbZBWLAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 06:00:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090222092722.GA12347@x200.localdomain>
References: <20090222092722.GA12347@x200.localdomain> <20090222001257.GA15755@x200.localdomain> <6395.1235263079@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: dhowells@redhat.com, kosaki.motohiro@jp.fujitsu.com, serue@us.ibm.com,
       mingo@elte.hu, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: Broken "User namespaces: Only put the userns when we unhash the uid"
Date: Mon, 23 Feb 2009 10:59:27 +0000
Message-ID: <4945.1235386767@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So, free_uid() calls free_user_ns(), which calls free_uid()...  Obvious,
really.   I wonder if free_user_ns() should always be deferred irrespective of
whether CONFIG_USER_SCHED is set.

David
