Return-Path: <linux-kernel-owner+w=401wt.eu-S1752945AbYABRmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbYABRmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 12:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYABRmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 12:42:00 -0500
Received: from mail.clusterfs.com ([74.0.229.162]:33748 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYABRl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 12:41:59 -0500
Date: Wed, 2 Jan 2008 10:41:57 -0700
From: Andreas Dilger <adilger@sun.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
Message-ID: <20080102174157.GD3351@webber.adilger.int>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080102013218.GO27566@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102013218.GO27566@does.not.exist>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 02, 2008  03:32 +0200, Adrian Bunk wrote:
> It might make sense to offer ext4 in -mm and even in early -rc kernels, 
> but I've already seen people using ext4 simply because a stable kernel 
> offered it - and that's definitely not intended.
> 
> Anyone who _really_ wants to test ext4 should anyway be able to do the 
> trivial change of removing the "depends on BROKEN" line.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> @@ -138,7 +138,7 @@ config EXT3_FS_SECURITY
>  
>  config EXT4DEV_FS
>  	tristate "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	depends on BROKEN
>  	select JBD2
>  	select CRC16
>  	help

Isn't CONFIG_EXPERIMENTAL enough?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

