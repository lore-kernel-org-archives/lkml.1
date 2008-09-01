Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbYIAMoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbYIAMoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 08:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbYIAMoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 08:44:09 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:45147 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbYIAMoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 08:44:08 -0400
Subject: Re: [patch 1/3] kmsg: Kernel message catalog macros.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Utz Bacher <utz.bacher@de.ibm.com>
Cc: mschwid2@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Gerrit Huizenga <gh@us.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Jan Kara <jack@suse.cz>,
       Jochen =?ISO-8859-1?Q?Vo=DF?= <jochen.voss@googlemail.com>,
       Joe Perches <joe@perches.com>,
       Kunai Takashi <kunai@linux-foundation.jp>,
       lf_kernel_messages@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-s390-owner@vger.kernel.org, Michael Holzheu <holzheu@de.ibm.com>,
       Pavel Machek <pavel@ucw.cz>, Randy Dunlap <randy.dunlap@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
       Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <OF576C88F7.D38E7FE6-ONC12574B1.00547361-C12574B1.005502D2@de.ibm.com>
References: <OF576C88F7.D38E7FE6-ONC12574B1.00547361-C12574B1.005502D2@de.ibm.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 01 Sep 2008 14:30:14 +0200
Message-Id: <1220272214.23719.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 17:28 +0200, Utz Bacher wrote:
> Martin Schwidefsky wrote on 25.08.2008 17:56:30:
> > If we go with hashes there is one more thing: kmsg(0, <string>)
> > The variant where we manually assign the message ids knows about the
> > "special" id 0. There is no documentation required for id 0 and none is
> > wanted. If we replace the manual ids with hashes this will get lost. You
> > could argue that a kmsg with id 0 is a normal printk so why not just use
> > printk? What is lost is the information that this printk has been found
> > to be not important enough to be documented. 
> 
> what about a kmsg(<string>) and a kmsg_not_for_doc(<string>) with only kmsg 
> being hashed and used for man pages. There might be better names for these 
> functions, though. 

That would double the number of macros we'd have to define. Not really
something I would like to do. Only if there is no other way ..

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


