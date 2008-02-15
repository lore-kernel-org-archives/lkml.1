Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbYBOC2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbYBOC2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 21:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760414AbYBOC2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 21:28:33 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51886 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760221AbYBOC2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 21:28:31 -0500
Date: Thu, 14 Feb 2008 18:27:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jengelh@computergmbh.de,
       matthew@wil.cx, randy.dunlap@oracle.com, daniel.ritz-ml@swissonline.ch,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging
 printk, take #3
Message-Id: <20080214182700.a9a706e9.akpm@linux-foundation.org>
In-Reply-To: <47B4EFAB.2040102@gmail.com>
References: <12028937731333-git-send-email-htejun@gmail.com>
	<20080213155701.48871761.akpm@linux-foundation.org>
	<47B38E13.1060503@gmail.com>
	<20080213170950.86945835.akpm@linux-foundation.org>
	<47B398B3.40308@gmail.com>
	<47B4EFAB.2040102@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 10:49:31 +0900 Tejun Heo <htejun@gmail.com> wrote:

> > printk is a special case, I think.  It's the primary logging/debugging
> > method which can't fail and as it's mostly interpreted by human beings
> > (and developers in problematic cases), it has different maneuvering room
> > on errors - ie. it's far better to print messages w/o header or proper
> > log level than failing to print, which is quite different requirements
> > from other components.
> 
> Andrew, any more comments or suggestions on how to proceed on this?

Nope.

>  One
> way or the other, I think this is a problem worth solving.

There are a lot of such problems ;)
