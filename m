Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYDUKCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYDUKCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbYDUKCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:02:33 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:27078 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbYDUKCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:02:32 -0400
Date: Mon, 21 Apr 2008 03:02:06 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make struct o2cb_stack_ops static
Message-ID: <20080421100206.GB7059@ca-server1.us.oracle.com>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
References: <20080421084931.GT26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421084931.GT26897@cs181133002.pp.htv.fi>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 11:49:31AM +0300, Adrian Bunk wrote:
> This patch makes the needlessly global struct o2cb_stack_ops static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Joel Becker <joel.becker@oracle.com>

> 
> ---
> eb3ca85e31f3ddec51aaab0fd2243962d7ce1bc6 diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
> index ac1d74c..bbd1667 100644
> --- a/fs/ocfs2/stack_o2cb.c
> +++ b/fs/ocfs2/stack_o2cb.c
> @@ -385,7 +385,7 @@ static int o2cb_cluster_this_node(unsigned int *node)
>  	return 0;
>  }
>  
> -struct ocfs2_stack_operations o2cb_stack_ops = {
> +static struct ocfs2_stack_operations o2cb_stack_ops = {
>  	.connect	= o2cb_cluster_connect,
>  	.disconnect	= o2cb_cluster_disconnect,
>  	.hangup		= o2cb_cluster_hangup,
> 

-- 

"What does it say about a society's priorities when the time you
 spend in meetings on Monday is greater than the total number of
 hours you spent sleeping over the weekend?"
	- Nat Friedman

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
