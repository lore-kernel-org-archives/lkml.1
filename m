Return-Path: <linux-kernel-owner+w=401wt.eu-S1756461AbYAHWs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbYAHWs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756152AbYAHWsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:48:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38269 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756113AbYAHWsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:48:05 -0500
Date: Tue, 8 Jan 2008 14:47:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, ecryptfs-devel@lists.sourceforge.net,
       thighlan@gmail.com
Subject: Re: [PATCH] eCryptfs: Load each file decryption key only once
Message-Id: <20080108144702.a5c0624f.akpm@linux-foundation.org>
In-Reply-To: <20080108211733.GD10989@localhost.austin.ibm.com>
References: <1198289130.8560.14.camel@buster2>
	<20080108211733.GD10989@localhost.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 15:17:33 -0600
Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> On Fri, Dec 21, 2007 at 08:05:30PM -0600, Trevor Highland wrote:
> > eCryptfs: Load each file decryption key only once
> > 
> > There is no need to keep re-setting the same key for any given
> > eCryptfs inode. This patch optimizes the use of the crypto API and
> > helps performance a bit.
> 
> There is no reason for the crypt_stat->key value for any given
> eCryptfs inode to change during the life of the inode, and each
> crypt_stat gets its own crypto transform, so I do not see a problem
> with Trevor's suggestion. It will save unnecessary calls to
> crypto_blkcipher_setkey(), and I expect it will speed things up a
> little.
> 
> I include an updated patch against 2.6.24-rc7.
> 

Your new patch clashes horridly with the pending
ecryptfs-set-inode-key-only-once-per-crypto-operation.patch.

I shall drop ecryptfs-load-each-file-decryption-key-only-once.patch and shall
then sit back and sulk.

