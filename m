Return-Path: <linux-kernel-owner+w=401wt.eu-S932216AbXIRR0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbXIRR0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757922AbXIRR0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:26:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbXIRR0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:26:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1190133857.6656.20.camel@heimdal.trondhjem.org>
References: <1190133857.6656.20.camel@heimdal.trondhjem.org> <1577.1189713412@redhat.com> <11807.1190133197@redhat.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: Credentials test patch
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 18 Sep 2007 18:25:41 +0100
Message-ID: <5314.1190136341@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> What about the process' capabilities? Shouldn't they also be part of a
> credential?

Quite probably.  The cred struct is not closed at this point.  I certainly
would like to move some of the stuff hidden behind the security pointer in the
task struct, at least for the purpose of acting on things.  For things that
act on the task, the task struct needs a resident label that controls that.

David
