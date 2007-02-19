Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbXBSLiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbXBSLiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932113AbXBSLiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:38:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104AbXBSLiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:38:04 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070218214415.GA4232@tv-sign.ru> 
References: <20070218214415.GA4232@tv-sign.ru> 
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers/media/video/cpia_pp.c: don't use _WORK_NAR 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 19 Feb 2007 11:37:18 +0000
Message-ID: <8637.1171885038@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> wrote:

> pp_cam_entry->cb_task need not to be _NOAUTOREL ... because in fact it is
> never used ???

That's a remarkably good point.  Did something get deleted since I made my
modifications?  Perhaps the workqueue stuff in that file should just be
deleted entirely.

Acked-By: David Howells <dhowells@redhat.com>
