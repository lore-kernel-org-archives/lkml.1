Return-Path: <linux-kernel-owner+w=401wt.eu-S1760169AbYHCXhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169AbYHCXhP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 19:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758880AbYHCXhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 19:37:01 -0400
Received: from smtprelay08.ispgateway.de ([80.67.29.8]:58959 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758757AbYHCXhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 19:37:00 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Keith Packard <keithp@keithp.com>
Subject: files/process scaling problem? (was: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM)
Date: Mon, 4 Aug 2008 01:35:31 +0200
User-Agent: KMail/1.9.9
Cc: John Stoffel <john@stoffel.org>, Christoph Hellwig <hch@infradead.org>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
References: <1217573919-7496-1-git-send-email-eric@anholt.net> <18581.43362.460694.60862@stoffel.org> <1217785943.23437.330.camel@koto.keithp.com>
In-Reply-To: <1217785943.23437.330.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808040135.32563.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith,

On Sunday 03 August 2008, Keith Packard wrote:
> > Just seeing your statement that you wanted to add ioctls made me
> > shudder and try to visuallize a better way to do this.  
> 
> I could use fds if the kernel supported applications needing many
> thousand of them, and also some way to keep these FDs from polluting the
> fd space used by select(2) (yeah, I know, don't use select).

You may just have identified a scaling problem here. 
I see no difference to many thousand TCP/IP connections in your description.

What actions on many thousand fds are supported poorly or not at all?
Are you only concerned about the memory requirements?

Please elaborate or point me to a place where you did already :-)


Best Regards

Ingo Oeser
