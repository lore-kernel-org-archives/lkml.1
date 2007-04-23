Return-Path: <linux-kernel-owner+w=401wt.eu-S932500AbXDWXnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbXDWXnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932564AbXDWXnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:43:19 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:35852 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500AbXDWXnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:43:18 -0400
Date: Mon, 23 Apr 2007 19:43:15 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Roland McGrath <roland@redhat.com>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Return EPERM not ECHILD on security_task_wait failure
Message-ID: <Line.LNX.4.64.0704231940560.5763@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Roland McGrath wrote:

> This patch makes do_wait return -EPERM instead of -ECHILD if some
> children were ruled out solely because security_task_wait failed.

What about using the return value from the security_task_wait hook (which 
should be -EACCES) ?


- James
-- 
James Morris
<jmorris@namei.org>
