Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbXE3RMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbXE3RMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbXE3RMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:12:13 -0400
Received: from smtp104.sbc.mail.re2.yahoo.com ([68.142.229.101]:33887 "HELO
	smtp104.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753910AbXE3RMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:12:12 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 May 2007 13:12:12 EDT
X-YMail-OSG: jkGYUiQVM1lMn5GuDgSvymRfwhOO_t3PbokgcLZNVXTcBoMgIThJ.KXeatLFP8vz3flUIGfczw--
Date: Wed, 30 May 2007 10:05:30 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Michal Marek <mmarek@suse.cz>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] Fix XFS_IOC_FSGEOMETRY_V1 in compat mode
Message-ID: <20070530170530.GA4197@tuatara.stupidest.org>
References: <20070530125954.706423971@suse.cz> <20070530143043.216024061@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530143043.216024061@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 02:59:55PM +0200, Michal Marek wrote:

> +typedef struct xfs_fsop_geom_v132 {

wouldn't xfs_fsop_geom_v1_32
                         ^

> +	__u32		blocksize;	/* filesystem (data) block size */

[...]

> +	__u32		dirblocksize;	/* directory block size, bytes	*/
> +} __attribute__((packed)) xfs_fsop_geom_v132_t;

and xfs_fsop_geom_v1_32_t
                    ^

read better there?

