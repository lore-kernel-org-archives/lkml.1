Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbYAQS31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbYAQS31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYAQS3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:29:20 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:4941 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYAQS3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:29:19 -0500
Date: Thu, 17 Jan 2008 18:30:01 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][try #2] checkpatch: clear the report buffer after processing a file
Message-ID: <20080117183001.GD1072@shadowen.org>
References: <478C80B3.4060106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478C80B3.4060106@cn.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 05:45:23PM +0800, Li Zefan wrote:
> 
> When checking multiple files, the report buffer is not cleared
> after processing a file, thus the report will be printed again
> and again, mixing up with other reports.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Yep, this is clearly broken.  Never used it with more than one file.  We
also accumulate the files in the current version.  I'll fix that up as I
merge this.

Thanks for the patch.

-apw
