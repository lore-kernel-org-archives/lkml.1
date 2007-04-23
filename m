Return-Path: <linux-kernel-owner+w=401wt.eu-S965679AbXDWHnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965679AbXDWHnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 03:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965685AbXDWHnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 03:43:08 -0400
Received: from twin.jikos.cz ([213.151.79.26]:36805 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965679AbXDWHnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 03:43:06 -0400
Date: Mon, 23 Apr 2007 09:42:50 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: pwarudkar@aol.com
cc: Andrew Morton <akpm@linux-foundation.org>, dsk6@pitt.edu,
       linux-kernel@vger.kernel.org
Subject: Re: Sleep during spinlock in TPM driver
In-Reply-To: <alpine.DEB.0.82.0704221505370.14039@paragw-desktop>
Message-ID: <Pine.LNX.4.64.0704230941390.20657@twin.jikos.cz>
References: <alpine.DEB.0.82.0704221505370.14039@paragw-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2007, Parag Warudkar wrote:

> @@ -1097,8 +1097,13 @@
> 
>   	/* Driver specific per-device data */
>   	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
> -	if (chip == NULL)
> +	devname = kmalloc(DEVNAME_SIZE, GFP_KERNEL);
> + +	if (chip == NULL || devname == NULL) {

Hi,

this line looks bogus to me.

-- 
Jiri Kosina
