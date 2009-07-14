Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbZGNOJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbZGNOJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbZGNOJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:09:18 -0400
Received: from cmpxchg.org ([85.214.51.133]:35212 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbZGNOJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:09:18 -0400
Date: Tue, 14 Jul 2009 16:08:39 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] block: slightly optimize blkdev_ioctl BLKRA{SET,GET}
Message-ID: <20090714140839.GA18146@cmpxchg.org>
References: <1247572794-24107-1-git-send-email-dfeng@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247572794-24107-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 07:59:54PM +0800, Xiaotian Feng wrote:
> Slightly optimize blkdev_ioctl by using shift instead of multiply
> and divide.

Does it make an actual difference in the object code for you?  I don't
have a single multiplication in that function after compilation.

	Hannes
