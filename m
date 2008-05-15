Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbYEOAA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbYEOAA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 20:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYEOAAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 20:00:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:37053 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbYEOAAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 20:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K1bouatIFiMNyQg/Z9b9s8DHhKz6jA7vL0pAcigvRk8+N8xmT03E5WrtFWHlt6tB4xzDOnGtp4BadKQ3QKAs/aXoJj64X5HycnFPowZRix9sCYd6Q9L1q0Tya145d/FaDl38+rOg5nOXa+wBpJ7n0t7eQAYJjs38ncLy1ZJKUYU=
Message-ID: <a4e6962a0805141700x3565e40fieda66f8a5a0a4d7a@mail.gmail.com>
Date: Wed, 14 May 2008 19:00:12 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: 2.6.26-rc2-mm1 (p9 build error when 9P_FS=n)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       v9fs-developer@lists.sourceforge.net
In-Reply-To: <20080514141630.bcf8d0cd.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	 <20080514141630.bcf8d0cd.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is probably a side effect of the merge issue v9fs-devel and -mm
had last week.  It should no longer be possible with the code that's
been in my v9fs-devel tree on kernel.org for the past 5 days
(CONFIG_NET_9P_FD no longer exists).

             -eric


On Wed, May 14, 2008 at 4:16 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Wed, 14 May 2008 01:01:29 -0700 Andrew Morton wrote:
>
>>
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc2/2.6.26-rc2-mm1/
>
> net/built-in.o: In function `init_p9':
> mod.c:(.init.text+0x4b0d): undefined reference to `p9_trans_fd_init'
> make[1]: *** [.tmp_vmlinux1] Error 1
>
>
> CONFIG_NET_9P=y
> CONFIG_NET_9P_FD=m
> CONFIG_NET_9P_VIRTIO=m
> CONFIG_NET_9P_DEBUG=y
>
> # CONFIG_9P_FS is not set
>
>
> ---
> ~Randy
>
