Return-Path: <linux-kernel-owner+w=401wt.eu-S1760020AbXEQRsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbXEQRsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757128AbXEQRsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:48:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475AbXEQRsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:48:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <6333.1179405001@redhat.com>
References: <6333.1179405001@redhat.com> <464BF8B2.3080101@yahoo.com.au> <464B3F2D.9030603@yahoo.com.au> <464B3209.4010003@yahoo.com.au> <464B07EC.4050308@yahoo.com.au> <464AF3F3.30204@yahoo.com.au> <20070516100225.18685.51699.stgit@warthog.cambridge.redhat.com> <17173.1179321391@redhat.com> <19714.1179331928@redhat.com> <23262.1179334587@redhat.com> <31162.1179341123@redhat.com> 
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement shared-writable mmap [try #2]
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Thu, 17 May 2007 18:46:53 +0100
Message-ID: <8493.1179424013@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> When making a StoreData call to the AFS server, I send all the parameters
> first, and at that point, the server will abort it, I think, if permission is
> not available, and won't wait for the payload to be delivered.

Make that "should abort it".  openafs-1.4.2 seems to let you execute a
StoreData, even if you don't have permission to do so.  I can tell I don't
have permission to do so because the reply from the StoreData op says so...

David
