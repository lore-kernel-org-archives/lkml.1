Return-Path: <linux-kernel-owner+w=401wt.eu-S934082AbXGLCEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbXGLCEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 22:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764604AbXGLCEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 22:04:32 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:56272 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764844AbXGLCEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 22:04:31 -0400
Date: Wed, 11 Jul 2007 22:04:28 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 05/11] security: revalidate rw permissions for sys_splice
 and sys_vmsplice
In-Reply-To: <Line.LNX.4.64.0707082257390.12256@d.namei>
Message-ID: <Line.LNX.4.64.0707112202120.29292@d.namei>
References: <Line.LNX.4.64.0707082253040.12256@d.namei>
 <Line.LNX.4.64.0707082257390.12256@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007, James Morris wrote:

> Revalidate read/write permissions for splice(2) and vmslice(2), in case 
> security policy has changed since the files were opened.

This patch clashes with changes which came in via Jens (who I'll submit 
the patch via once it's fixed).

I'll send an updated pull request with this patch removed from the branch.


- James
-- 
James Morris
<jmorris@namei.org>
