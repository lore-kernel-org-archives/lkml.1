Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYAQDEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYAQDEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 22:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYAQDEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 22:04:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46891 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYAQDEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 22:04:10 -0500
Message-ID: <478EC131.8030103@zytor.com>
Date: Wed, 16 Jan 2008 21:45:05 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       linuxram@us.ibm.com, viro@ftp.linux.org.uk, hch@infradead.org,
       a.p.zijlstra@chello.nl
Subject: Re: [patch] VFS: extend /proc/mounts
References: <E1JFGUp-00054z-KQ@pomaz-ex.szeredi.hu> <20080116143051.ec488f3d.akpm@linux-foundation.org>
In-Reply-To: <20080116143051.ec488f3d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> Seems like a plain bad idea to me.  There will be any number of home-made
> /proc/mounts parsers and we don't know what they do.
> 

There is a lot of precedent for adding fields at the end.  Since the 
last fields in current /proc/*/mounts are dummy fields anyway, it 
doesn't matter if the homegrown parsers concatenate the additional 
information to those.

	-hpa
