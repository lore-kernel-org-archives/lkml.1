Return-Path: <linux-kernel-owner+w=401wt.eu-S1762260AbYDBVTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762260AbYDBVTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbYDBVTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:19:43 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49624 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835AbYDBVTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:19:42 -0400
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080402201321.062856131@szeredi.hu>
References: <20080402201247.358430231@szeredi.hu>
	 <20080402201321.062856131@szeredi.hu>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 14:19:39 -0700
Message-Id: <1207171179.23710.50.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think these definitely all clean the code up.  They might add a couple
of lines, net, but they certainly make it easier to read.  As you noted,
they also make it much harder to screw up the locking, which is even
better.  Just looking at it from an aesthetic point of view, it looks
good to have these helpers around.

-- Dave

