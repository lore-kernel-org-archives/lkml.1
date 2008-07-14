Return-Path: <linux-kernel-owner+w=401wt.eu-S1755064AbYGNAtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbYGNAtJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 20:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbYGNAs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 20:48:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45847
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753422AbYGNAsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 20:48:55 -0400
Date: Sun, 13 Jul 2008 17:48:55 -0700 (PDT)
Message-Id: <20080713.174855.234796356.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: andi@firstfloor.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0807131947090.7803@devserv.devel.redhat.com>
References: <20080713.124610.193703496.davem@davemloft.net>
	<487A61DD.6090304@firstfloor.org>
	<Pine.LNX.4.64.0807131947090.7803@devserv.devel.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Sun, 13 Jul 2008 19:53:01 -0400 (EDT)

> There is no need to turn BIO merge off --- the problem is caused by 
> accounting of BIO merging in block layer, not by BIO merging itself.
> 
> Just do #define BIO_VMERGE_BOUNDARY 0, and that disables the accounting, 
> but leaves merging as it is.

For the thousanth time, the BIO_VMERGE_BOUNDARY code is useful
and worked perfectly fine before segment boundary handling was
added to the block layer.

It's a regression, and as such should be fixed or the guilty
code reverted.

Since when do we say "sorry that got broken, turn it off, thanks"
?
