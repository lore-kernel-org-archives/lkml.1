Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbYAWUtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbYAWUtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 15:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbYAWUsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 15:48:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbYAWUsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 15:48:51 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1201112977.5443.29.camel@localhost.localdomain>
References: <1201112977.5443.29.camel@localhost.localdomain>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Al Viro <viro@ftp.linux.org.uk>, William H Taber <wtaber@us.ibm.com>,
       William Cesar de Oliveira <owilliam@br.ibm.com>,
       Richard Kissel <rkissel@us.ibm.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] Fix procfs task exe symlink
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 23 Jan 2008 20:46:31 +0000
Message-ID: <22275.1201121191@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Helsley <matthltc@us.ibm.com> wrote:

> To solve the problem this patch changes the way that the kernel resolves a
> task's exe symlink. Instead of walking the VMAs to find the first
> executable file-backed VMA we store a reference to the exec'd file in the
> mm_struct -- /foo/bar/jvm/bin/java in the example above.

Sounds interesting.

> 	nommu-only code paths are untested -- lacking access to nommu system

I could test it, but it'll have to wait until I get back from LCA in a couple
of weeks time.

David
