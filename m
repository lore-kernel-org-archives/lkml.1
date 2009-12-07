Return-Path: <linux-kernel-owner+w=401wt.eu-S935679AbZLGW6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935679AbZLGW6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935639AbZLGW6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:58:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935616AbZLGW6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:58:21 -0500
Date: Mon, 7 Dec 2009 14:58:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, phillip.lougher@gmail.com,
       tim.bird@am.sony.com
Subject: Re: [PATCH 2/9] Squashfs: Factor out remaining zlib dependencies
 into separate wrapper file
Message-Id: <20091207145803.7e893bd7.akpm@linux-foundation.org>
In-Reply-To: <E1NHTHg-0001sR-PM@dylan.lougher.demon.co.uk>
References: <E1NHTHg-0001sR-PM@dylan.lougher.demon.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Dec 2009 02:25:08 +0000
Phillip Lougher <phillip@lougher.demon.co.uk> wrote:

> +void *zlib_init()
> ...
> +void zlib_free(void *strm)

More poorly-named globals.
