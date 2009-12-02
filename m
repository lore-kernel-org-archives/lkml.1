Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbZLBTDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbZLBTDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 14:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbZLBTDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 14:03:31 -0500
Received: from mail.vyatta.com ([76.74.103.46]:59036 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669AbZLBTDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 14:03:31 -0500
Date: Wed, 2 Dec 2009 11:03:26 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [PATCH 00/13] drivers/block/floppy.c: More cleanups
Message-ID: <20091202110326.2a48e5e4@nehalam>
In-Reply-To: <cover.1259733456.git.joe@perches.com>
References: <cover.1259733456.git.joe@perches.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Dec 2009 22:07:40 -0800
Joe Perches <joe@perches.com> wrote:

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

I like seeing it as individual patches like this, but the first batch
starts after your huge patch. Why not split that one up as well.

-- 
