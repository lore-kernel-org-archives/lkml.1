Return-Path: <linux-kernel-owner+w=401wt.eu-S1760474AbYEIMH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760474AbYEIMH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 08:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbYEIMHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 08:07:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbYEIMHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 08:07:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1209694461.24729.223.camel@brick>
References: <1209694461.24729.223.camel@brick> <1209683136.24729.207.camel@brick> <11442.1209694140@redhat.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/9] frv: gdb-stub.c use the common ascii hex helpers
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 09 May 2008 13:07:08 +0100
Message-ID: <14697.1210334828@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Everyone rolls their own version around the tree, centralize
> in lib/hexdump.c

Can you instruct that these are only to be used for GDB stubs?  Otherwise if
someone slaps a breakpoint in there accidentally, they might kill the GDB
stub.

David
