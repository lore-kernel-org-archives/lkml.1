Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbYFPMIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbYFPMIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 08:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYFPMIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 08:08:37 -0400
Received: from styx.suse.cz ([82.119.242.94]:48069 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751086AbYFPMIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 08:08:36 -0400
Date: Mon, 16 Jun 2008 14:08:35 +0200
From: Jan Kara <jack@suse.cz>
To: Paul Collins <paul@burly.ondioline.org>
Cc: jack@suse.cz, manciuleas@yahoo.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udf: restore UDFFS_DEBUG to being undefined by default
Message-ID: <20080616120834.GA31567@duck.suse.cz>
References: <87d4mkiwyk.fsf@burly.wgtn.ondioline.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d4mkiwyk.fsf@burly.wgtn.ondioline.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 14-06-08 14:14:59, Paul Collins wrote:
> Commit 706047a79725b585cf272fdefc234b31b6545c72, "udf: Fix compilation
> warnings when UDF debug is on" inadvertently (I assume) enabled
> debugging messages by default for UDF.  This patch disables them again.
  Oops, yes. Thanks for catching this. I'll merge the patch.

> Signed-off-by: Paul Collins <paul@ondioline.org>
> 
> diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
> index 8fa9c2d..8ec865d 100644
> --- a/fs/udf/udfdecl.h
> +++ b/fs/udf/udfdecl.h
> @@ -16,7 +16,7 @@
>  #define UDF_PREALLOCATE
>  #define UDF_DEFAULT_PREALLOC_BLOCKS	8
>  
> -#define UDFFS_DEBUG
> +#undef UDFFS_DEBUG
>  
>  #ifdef UDFFS_DEBUG
>  #define udf_debug(f, a...) \

								Honza

PS: Sorry for the bounce you probably got. I had misconfigured my mail
system for a while...
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
