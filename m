Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZLBRFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZLBRFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbZLBRFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:05:45 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46322 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbZLBRFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:05:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JhlsPHJroFf7/9BHV6KjX16ThXmLnwAy5CTmdy3UrwLzICghbMilso234WAaqFAwVu
         8XRuVA6s/sCMpV2uPk0GHxIT9Z8hfOn1VtJ1uWYqkGf0KWuAqYyj13QC9Ef8Abe6yCx+
         cE4laEPXeuHd5abCHajCGkToKedwKVhBHBH30=
Date: Wed, 2 Dec 2009 18:05:27 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/13] drivers/block/floppy.c: More cleanups
Message-ID: <20091202170527.GA3155@joi.lan>
References: <cover.1259733456.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1259733456.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 10:07:40PM -0800, Joe Perches wrote:
> Might as well make it cleaner...
> 
> Joe Perches (13):
>   drivers/block/floppy.c: Remove macro LOCK_FDC
>   drivers/block/floppy.c: Add debug_dcl(...) macro
>   drivers/block/floppy.c: Remove [U]CLEARF, [U]SETF, and [U]TESTF macros
>   drivers/block/floppy.c: Remove most uses of CALL and ECALL macros
>   drivers/block/floppy.c: remove [_]COPYIN [_]COPYOUT and ECALL macros
>   drivers/block/floppy.c: remove macros CALL, WAIT and IWAIT
>   drivers/block/floppy.c: convert int 1/0 to bool true/false
>   drivers/block/floppy.c: Move leading && and || to preceding line
>   drivers/block/floppy.c: remove #define DEVICE_NAME "floppy"
>   drivers/block/floppy.c: Convert int initialising to bool initialized
>   drivers/block/floppy.c: Add function is_ready_state
>   drivers/block/floppy.c: Readd SunOS eject cmd comment
>   drivers/block/floppy.c: Remove unnecessary return and braces
> 
>  drivers/block/floppy.c |  410 ++++++++++++++++++++++++------------------------
>  1 files changed, 208 insertions(+), 202 deletions(-)
> 

If you want to, you can add this line to these patches:
Reviewed-by: Marcin Slusarz <marcin.slusarz@gmail.com>
