Return-Path: <linux-kernel-owner+w=401wt.eu-S1757694AbYDNKXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbYDNKXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYDNKXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:23:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbYDNKXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:23:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0804140053210.9760@peripatetic.hades>
References: <Pine.LNX.4.64.0804140053210.9760@peripatetic.hades>
To: Arun Raghavan <arunsr@cse.iitk.ac.in>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, satyam@infradead.org
Subject: Re: [PATCH] [keys] Use mutex instead of rw_semaphore for __key_link() serialisation
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 14 Apr 2008 11:23:13 +0100
Message-ID: <2320.1208168593@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun Raghavan <arunsr@cse.iitk.ac.in> wrote:

> __key_link() uses an rw_semaphore as a mutex to serialise link/link calls. 
> This patch converts it to explicitly use a struct mutex.
> 
> Signed-off-by: Arun Raghavan <arunsr@cse.iitk.ac.in>
> Signed-off-by: Satyam Sharma <satyam@infradead.org>

Acked-by: David Howells <dhowells@redhat.com>
