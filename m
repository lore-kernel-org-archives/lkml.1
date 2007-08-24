Return-Path: <linux-kernel-owner+w=401wt.eu-S1764919AbXHXXty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764919AbXHXXty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 19:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbXHXXtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 19:49:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36691 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755487AbXHXXtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 19:49:46 -0400
Date: Fri, 24 Aug 2007 16:48:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-kernel@vger.kernel.org, david@dgreaves.com,
       Wouter Verhelst <w@uter.be>, Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH 1/2] NBD: set uninitialized devices to size 0
Message-Id: <20070824164856.7024a95b.akpm@linux-foundation.org>
In-Reply-To: <46CF101F.4050603@steeleye.com>
References: <46CF101F.4050603@steeleye.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 13:06:39 -0400
Paul Clements <paul.clements@steeleye.com> wrote:

> This fixes errors with utilities (such as LVM's vgscan) that try to scan 
> all devices. Previously this would generate read errors when 
> uninitialized nbd devices were scanned:

I somewhat randomly marked both these as 2.6.24 material.  If you think
that was incorrect, please shout out.
