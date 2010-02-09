Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0BIVl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 16:41:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753218Ab0BIVl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 16:41:58 -0500
Date: Tue, 9 Feb 2010 13:41:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Otavio Salvador <otavio@ossystems.com.br>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       linux-fbdev@vger.kernel.org
Subject: Re: i810fb: Breaks EDID for Xorg
Message-Id: <20100209134151.9ee5d4f4.akpm@linux-foundation.org>
In-Reply-To: <be7a9f3d1002080536v4c38f6e7k492fd09fdab72b5a@mail.gmail.com>
References: <be7a9f3d1002080536v4c38f6e7k492fd09fdab72b5a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-fbdev-devel)

On Mon, 8 Feb 2010 11:36:39 -0200
Otavio Salvador <otavio@ossystems.com.br> wrote:

> Hello,
> 
> After some time looking for why one system had EDID working, for Xorg,
> and other don't I found the reason being CONFIG_FB_I810.
> 
> When I enable CONFIG_FB_I810 the Xorg VBE reading fails; if I disable
> it, it works fine.
> 
> Anyone has any idea how to fix it?
> 

