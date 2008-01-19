Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbYASNss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbYASNss (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 08:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYASNsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 08:48:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbYASNsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 08:48:40 -0500
Date: Sat, 19 Jan 2008 11:48:37 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Rafael Sisto <rafael.sisto@gmail.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: new file in kernel.
Message-ID: <20080119134837.GA15610@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Rafael Sisto <rafael.sisto@gmail.com>,
	Linux kernel <linux-kernel@vger.kernel.org>
References: <ee3dc96c0801190542u2f91a2eax3bcfd0268d4850b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee3dc96c0801190542u2f91a2eax3bcfd0268d4850b4@mail.gmail.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Jan 19, 2008 at 10:42:40AM -0300, Rafael Sisto escreveu:
> Dear forum,
> can anybody help me with this issue?
> 
> How do I create a new file in kernel mode?
> I am trying to create a file in a system call I am building.

Look at how NFS does.

fs/nfsd/nfs3proc.c
nfsd3_proc_create

- Arnaldo
