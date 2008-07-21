Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbYGUJMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbYGUJMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbYGUJMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:12:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44359 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbYGUJMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:12:41 -0400
Date: Mon, 21 Jul 2008 10:12:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup()
Message-ID: <20080721091237.GC28946@ZenIV.linux.org.uk>
References: <4881BEF4.2020201@cn.fujitsu.com> <20080719131317.GA7027@asus> <20080719131909.GB7027@asus> <20080721052713.GY28946@ZenIV.linux.org.uk> <48842CDB.1090009@cn.fujitsu.com> <20080721070346.GA28946@ZenIV.linux.org.uk> <20080721080427.GC6662@lenovo> <488448A1.3030608@cn.fujitsu.com> <20080721084443.GD20011@lenovo> <48844FE4.1040708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48844FE4.1040708@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 04:59:16PM +0800, Li Zefan wrote:
> > well, as only Al find new version more or less correct we could
> > update yours.
> >  
> 
> Sorry, I don't quite catch what you mean for my poor English. :(
> 
> Do you expect me to update and resend my version? or do you mean don't
> drop the patch in -mm but you will resend a patch based against it?

<shrug>

FWIW, the latest posted variant looks sane.  Whether you want it in one
piece or two... up to you, folks.  Whichever way you do it, throw the
char * -> const char * transition for mnt_devname into the mix and send
the prefered splitup; I'll apply it after I get some sleep...
