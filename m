Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbZDNSXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbZDNSXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757681AbZDNSW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:22:59 -0400
Received: from mail2.shareable.org ([80.68.89.115]:57311 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbZDNSW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:22:58 -0400
Date: Tue, 14 Apr 2009 19:22:42 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jens.axboe@oracle.com, mfasheh@suse.com, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/6] splice: remove generic_file_splice_write_nolock()
Message-ID: <20090414182242.GG32311@shareable.org>
References: <20090414174835.487031939@szeredi.hu> <20090414174859.496563416@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414174859.496563416@szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> Remove the now unused generic_file_splice_write_nolock() function.
> It's conceptually broken anyway, because splice may need to wait for
> pipe events so holding locks across the whole operation is wrong.

Did the conceptual brokenness affect userspace behaviour of
splice/sendfile at all?

Thanks,
-- Jamie
