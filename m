Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYDUKCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYDUKCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYDUKC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:02:29 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:27055 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbYDUKC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:02:28 -0400
Date: Mon, 21 Apr 2008 03:01:53 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make struct ocfs2_control_device static
Message-ID: <20080421100153.GA7059@ca-server1.us.oracle.com>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
References: <20080421084926.GS26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421084926.GS26897@cs181133002.pp.htv.fi>
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

On Mon, Apr 21, 2008 at 11:49:26AM +0300, Adrian Bunk wrote:
> This patch makes the needlessly global struct ocfs2_control_device 
> static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Joel Becker <joel.becker@oracle.com>

> 
> ---
> d8837f8ed79bc615105e5ca2724c3d22c9f26089 diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index 7428663..b503772 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -635,7 +635,7 @@ static const struct file_operations ocfs2_control_fops = {
>  	.owner   = THIS_MODULE,
>  };
>  
> -struct miscdevice ocfs2_control_device = {
> +static struct miscdevice ocfs2_control_device = {
>  	.minor		= MISC_DYNAMIC_MINOR,
>  	.name		= "ocfs2_control",
>  	.fops		= &ocfs2_control_fops,
> 

-- 

Life's Little Instruction Book #356

	"Be there when people need you."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
