Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbYEEMgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbYEEMgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbYEEMgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:36:03 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59114 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbYEEMgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:36:01 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20080505110646.GF20910@infradead.org> (message from Christoph
	Hellwig on Mon, 5 May 2008 07:06:46 -0400)
Subject: Re: [patch 12/15] vfs: create file_truncate() helper
References: <20080505095440.820370974@szeredi.hu> <20080505095526.823086058@szeredi.hu> <20080505110646.GF20910@infradead.org>
Message-Id: <E1Jszv9-0005vn-Ib@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 05 May 2008 14:35:55 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, May 05, 2008 at 11:54:53AM +0200, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Clean up do_truncate() API:
> > 
> >   - create a new function file_truncate()
> >   - remove the 'struct file *' argument from do_truncate()
> 
> file_truncate looks like a nice little cleanup, but please make sure to
> add a kerneldoc comment for every newly added global function.

OK.

> I don't think there's a point to remove the file argument from
> do_truncate and add another helper.

Whatever.

Miklos
