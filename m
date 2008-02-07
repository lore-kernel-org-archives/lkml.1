Return-Path: <linux-kernel-owner+w=401wt.eu-S934801AbYBGVo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934801AbYBGVo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757944AbYBGVor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:44:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37397 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757395AbYBGVoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:44:46 -0500
Date: Thu, 7 Feb 2008 13:44:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Clem Taylor" <clem.taylor@gmail.com>
Cc: ulissesf@gmail.com, linux-kernel@vger.kernel.org, amy.griffis@hp.com
Subject: Re: inotify_add_watch() returning ENOSPC in 2.6.24 [watch
 descriptor leak?]
Message-Id: <20080207134441.00a4cd33.akpm@linux-foundation.org>
In-Reply-To: <ecb4efd10802071324n3582fdfai3154a3a488ade2fd@mail.gmail.com>
References: <ecb4efd10802051749n6a626e84k3ac8210aa2b5a446@mail.gmail.com>
	<20080206015103.9a0f4069.akpm@linux-foundation.org>
	<ecb4efd10802061140g929e699y8d79f1317c30478d@mail.gmail.com>
	<d23110170802071054s6fef54c9q182a9ed2e180052@mail.gmail.com>
	<ecb4efd10802071324n3582fdfai3154a3a488ade2fd@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 16:24:15 -0500
"Clem Taylor" <clem.taylor@gmail.com> wrote:

> On Feb 7, 2008 1:54 PM, Ulisses Furquim <ulissesf@gmail.com> wrote:
> > Ok, I had a go with it and found the problem. We weren't releasing
> > one-shot watches because the test for them was wrong. We're using the
> > event's mask to test for one-shot watches when we should've been using
> > the watch's mask.
> 
> Thanks, this patch seems to fix the problem.
> 

Awesome. Thanks, guys.
