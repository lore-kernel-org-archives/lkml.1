Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbYDBCJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbYDBCJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 22:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbYDBCIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 22:08:53 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3802 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbYDBCIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 22:08:53 -0400
Subject: Re: [patch 1/3] dynamic printk - core infrastructure
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080401144744.d0d10504.randy.dunlap@oracle.com>
References: <20080401194951.GC12029@redhat.com>
	 <20080401144744.d0d10504.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 19:07:24 -0700
Message-Id: <1207102044.23161.163.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-01 at 14:47 -0700, Randy Dunlap wrote:
> > echo "add file.c" > /sys/kernel/debug/dynamic_printk/files
> > echo "remove file.c" > /sys/kernel/debug/dynamic_printk/files

I think this would be better by module rather than filename.
KBUILD_MODNAME would be a better choice.


