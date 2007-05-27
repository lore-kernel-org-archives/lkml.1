Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbXE0AMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbXE0AMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 20:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbXE0AM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 20:12:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbXE0AM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 20:12:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <A02B7736-39AA-4B50-B682-756C387AEDEC@mac.com>
References: <A02B7736-39AA-4B50-B682-756C387AEDEC@mac.com> <20070524165554.22292.38887.stgit@warthog.cambridge.redhat.com> <20070526022342.GA20905@fieldses.org>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement file locking
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Sun, 27 May 2007 01:12:19 +0100
Message-ID: <7957.1180224739@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett <mrmacman_g4@mac.com> wrote:

> I was actually under the impression that OpenAFS had support for byte- 
> range locking (as well as lock upgrade/downgrade);

As far as I know, there is no support for byte-range locking at all in the AFS
protocol itself.  The client can try to emulate byte-range locking locally,
but that's about it.

David
