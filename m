Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYEOHjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYEOHjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYEOHjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:39:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37786 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbYEOHjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:39:05 -0400
Date: Thu, 15 May 2008 08:39:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       drepper@redhat.com
Subject: Re: [patch 13/24] vfs: utimes cleanup
Message-ID: <20080515073901.GT13907@ZenIV.linux.org.uk>
References: <20080506091327.259950960@szeredi.hu> <20080506091422.705393283@szeredi.hu> <E1JtK1S-00018D-55@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JtK1S-00018D-55@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 12:03:46PM +0200, Miklos Szeredi wrote:
> + * do_futimesat - change times on filename

> +int do_utimes(int dfd, char __user *filename, struct timespec *times, int flags)

Erm...  Is there any reason to
	* have do_utimes() used anywhere
	* _not_ have do_futimesat() called "do_utimes"?
