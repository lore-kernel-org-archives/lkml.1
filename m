Return-Path: <linux-kernel-owner+w=401wt.eu-S932546AbZDAOzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbZDAOzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762246AbZDAOzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:55:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52152 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbZDAOzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:55:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090401001427.GG29821@us.ibm.com>
References: <20090401001427.GG29821@us.ibm.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: dhowells@redhat.com, Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] Remove struct mm_struct::exe_file et al
Date: Wed, 01 Apr 2009 15:53:55 +0100
Message-ID: <30254.1238597635@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Helsley <matthltc@us.ibm.com> wrote:

> all binary format handlers place the executable low in the mmap

Not so, at least not on NOMMU, and possibly not so with randomised executable
mappings either.

David
