Return-Path: <linux-kernel-owner+w=401wt.eu-S1762777AbYDOJLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777AbYDOJLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 05:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756822AbYDOJLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 05:11:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756760AbYDOJLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:11:35 -0400
Date: Tue, 15 Apr 2008 02:10:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q? "Ilpo_J=E4rvinen" ?= <ilpo.jarvinen@helsinki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] smb.h: uses struct timespec but didn't include
 linux/time.h
Message-Id: <20080415021057.9bdff72f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0804151202390.17123@wrl-59.cs.helsinki.fi>
References: <Pine.LNX.4.64.0804151202390.17123@wrl-59.cs.helsinki.fi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 12:04:04 +0300 (EEST) "Ilpo J__rvinen" <ilpo.jarvinen@helsinki.fi> wrote:

> 
> Signed-off-by: Ilpo J__rvinen <ilpo.jarvinen@helsinki.fi>
> ---
>  include/linux/smb.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/smb.h b/include/linux/smb.h
> index f098dff..caa43b2 100644
> --- a/include/linux/smb.h
> +++ b/include/linux/smb.h
> @@ -11,6 +11,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/magic.h>
> +#include <linux/time.h>
>  
>  enum smb_protocol { 
>  	SMB_PROTOCOL_NONE, 

Did this actually cause a compilation error?
