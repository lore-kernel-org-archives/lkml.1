Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbXFUPjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbXFUPjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 11:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbXFUPjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 11:39:17 -0400
Received: from xenotime.net ([66.160.160.81]:37857 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752336AbXFUPjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 11:39:16 -0400
Date: Thu, 21 Jun 2007 08:41:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
Subject: Re: [PATCH] Move functions declarations to header file
Message-Id: <20070621084101.73254fe7.rdunlap@xenotime.net>
In-Reply-To: <20070621145411.GA26091@redhat.com>
References: <20070621145411.GA26091@redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007 11:54:11 -0300 Glauber de Oliveira Costa wrote:

> Some interrupt entry points are currently defined in i8259.c
> They probably belong in a header. Right now, their only user is
> init_IRQ, justifying their declaration in-file. But when virtualization
> comes in, we may be interested in using that functions in late
> initializations.
> 
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

Patch is OK with me, but please insert patches inline in emails.
Lots of people who use mutt do this, so it must work and is the
preferred way.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
