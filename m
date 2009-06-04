Return-Path: <linux-kernel-owner+w=401wt.eu-S1752192AbZFDR57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbZFDR57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbZFDR5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:57:43 -0400
Received: from kroah.org ([198.145.64.141]:39931 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbZFDR5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:57:42 -0400
Date: Thu, 4 Jun 2009 10:52:19 -0700
From: Greg KH <greg@kroah.com>
To: Yunpeng Gao <yunpeng.gao@intel.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for June 3 (staging)
Message-ID: <20090604175219.GA18605@kroah.com>
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au> <4A2695C1.2060104@oracle.com> <20090603152558.GA25725@suse.de> <4A269971.1050004@oracle.com> <20090603231152.GA18701@suse.de> <20090604232610.GA16053@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090604232610.GA16053@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 07:26:10AM +0800, Yunpeng Gao wrote:
>    I have fixed these compiling bugs in file ffsport.c.
> 
>    But just found that my email client (Outlook) will replace
>    TAB with blanks automatically. So, unfortunately, all the
>    TABs in my first submission patch have been changed to
>    blanks by the Outlook.
>    
>    So I'd like to use the Mutt email client and re-submit
>    the patch as below (the bug-fix of ffsport.c has been included).
>    Does it make sense?
> 

Are you sure you included the fixed up patch?

With the patch you submitted below, I get the following build errors:

drivers/staging/mrst_nand/ffsport.c: In function ‘do_transfer’:
drivers/staging/mrst_nand/ffsport.c:360: error: implicit declaration of function ‘blk_rq_pos’
drivers/staging/mrst_nand/ffsport.c:376: error: implicit declaration of function ‘blk_rq_cur_sectors’
drivers/staging/mrst_nand/ffsport.c: In function ‘spectra_trans_thread’:
drivers/staging/mrst_nand/ffsport.c:499: error: implicit declaration of function ‘blk_fetch_request’
drivers/staging/mrst_nand/ffsport.c:499: warning: assignment makes pointer from integer without a cast
drivers/staging/mrst_nand/ffsport.c:515: error: implicit declaration of function ‘__blk_end_request_cur’
drivers/staging/mrst_nand/ffsport.c:520: error: implicit declaration of function ‘__blk_end_request_all’
drivers/staging/mrst_nand/ffsport.c: In function ‘SBD_setup_device’:
drivers/staging/mrst_nand/ffsport.c:741: error: implicit declaration of function ‘blk_queue_logical_block_size’
make[3]: *** [drivers/staging/mrst_nand/ffsport.o] Error 1
make[3]: *** Waiting for unfinished jobs....


I'll just drop this patch for now, can you resend it to me when it is
fixed up properly?

thanks,

greg k-h
