Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbYIJWgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbYIJWgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbYIJWfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:35:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753385AbYIJWfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:35:50 -0400
Date: Wed, 10 Sep 2008 15:35:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Greg KH <greg@kroah.com>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Message-Id: <20080910153507.979131ce.akpm@linux-foundation.org>
In-Reply-To: <48C68507.6000609@suse.com>
References: <48C68507.6000609@suse.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Sep 2008 10:15:35 -0400
Jeff Mahoney <jeffm@suse.com> wrote:

>  Every kernel package trying to provide files under /lib/firmware runs
>  into problems really quickly with multiple kernels installed, especially
>  with respect to distribution package tracking of the files.

For how long has this problem existed?

>  This patch moves them to /lib/firmware/$KERNELRELEASE. udev v127's
>  firmware.sh looks there first before falling back to /lib/firmware.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/Makefile
> +++ b/Makefile
> @@ -1025,7 +1025,7 @@ depend dep:
>  
>  # ---------------------------------------------------------------------------
>  # Firmware install
> -INSTALL_FW_PATH=$(INSTALL_MOD_PATH)/lib/firmware
> +INSTALL_FW_PATH=$(INSTALL_MOD_PATH)/lib/firmware/$(KERNELRELEASE)
>  export INSTALL_FW_PATH
>  
>  PHONY += firmware_install
> 

