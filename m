Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbZKSXG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbZKSXG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 18:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757870AbZKSXG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 18:06:57 -0500
Received: from kroah.org ([198.145.64.141]:41170 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376AbZKSXG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 18:06:56 -0500
Date: Thu, 19 Nov 2009 14:56:02 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: Re: [PATCH 2/3] staging/dream: add missing include files
Message-ID: <20091119225602.GC18710@kroah.com>
References: <20091101222717.GB20740@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091101222717.GB20740@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 01, 2009 at 11:27:17PM +0100, Pavel Machek wrote:
> Add missing files/includes neccessary for Dream compilation.
>     
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

This patch includes a file that is not in the drivers/staging/
directory, and it does this Kconfig mess:

> +config GENERIC_GPIO
> +	bool
> +	default y

Which breaks the i386 build.  Don't force on a general config option
like this, that's not nice at all :(

So I'll not apply this one, and the 3/3 patch.

thanks,

greg k-h
