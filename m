Return-Path: <linux-kernel-owner+w=401wt.eu-S1760402AbZFQTyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760402AbZFQTyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 15:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZFQTyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 15:54:04 -0400
Received: from sous-sol.org ([216.99.217.87]:43385 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbZFQTyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 15:54:03 -0400
Date: Wed, 17 Jun 2009 12:54:02 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.30 - kernel BUG at lib/kernel_lock.c:126!
Message-ID: <20090617195402.GA19771@sequoia.sous-sol.org>
References: <b6a2187b0906170855t5dc7c0c1q48b3c7dca4254594@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0906170855t5dc7c0c1q48b3c7dca4254594@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeff Chua (jeff.chua.linux@gmail.com) wrote:
> Executing "mount -o remount -r" on a busy reiserfs filesystem causes
> the following oops.
> 
> Sync will just hang after this oops. Happens on 2.6.30.
> 
> If there's no activity on the partition, sync, sync, and remount as
> read-only will be ok. No oops.

This fix is queued up in viro's tree already.

http://git.kernel.org/?p=linux/kernel/git/viro/vfs-2.6.git;a=commit;h=b0895513f499b8f786d292ce48589ca210ca1d6e

thanks,
-chris
