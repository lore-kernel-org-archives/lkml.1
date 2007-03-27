Return-Path: <linux-kernel-owner+w=401wt.eu-S934178AbXC0TFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934178AbXC0TFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934188AbXC0TFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:05:13 -0400
Received: from smtp.osdl.org ([65.172.181.24]:38383 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934178AbXC0TFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:05:12 -0400
Date: Tue, 27 Mar 2007 12:05:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
Message-Id: <20070327120500.8450410e.akpm@linux-foundation.org>
In-Reply-To: <E1HWGpj-0004Yb-00@dorka.pomaz.szeredi.hu>
References: <20070327184227.13923.qmail@science.horizon.com>
	<E1HWGpj-0004Yb-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 20:55:51 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> It's actually wrong about FADV_DONTNEED, which I think doesn't start
> writeout either.

        case POSIX_FADV_DONTNEED:
                if (!bdi_write_congested(mapping->backing_dev_info))
                        filemap_flush(mapping);
