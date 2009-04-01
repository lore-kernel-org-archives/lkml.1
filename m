Return-Path: <linux-kernel-owner+w=401wt.eu-S1764766AbZDAM5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764766AbZDAM5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761587AbZDAM4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:56:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33909 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762559AbZDAM4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:56:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090401011344.GB22398@x200.localdomain>
References: <20090401011344.GB22398@x200.localdomain> <200903302344.n2UNi3xd027136@imap1.linux-foundation.org> <20090331144051.GA3951@redhat.com> <20090401003223.GH29821@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: dhowells@redhat.com, Matt Helsley <matthltc@us.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com, hch@lst.de
Subject: Re: + mm-remove-struct-mm_struct-exe_file-et-al.patch added to -mm tree
Date: Wed, 01 Apr 2009 13:55:57 +0100
Message-ID: <22191.1238590557@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> wrote:

> and, as was mentioned, file is mapped low, so it'd be among the first VMAs.

Not so on NOMMU.  The file is mapped wherever the allocator happens to throw up
a sufficient quantity of contiguous pages.  It may not even be mapped in RAM.

David
