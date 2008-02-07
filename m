Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbYBGPdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbYBGPdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 10:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbYBGPdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 10:33:23 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:59672 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbYBGPdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 10:33:22 -0500
Date: Thu, 7 Feb 2008 21:03:15 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/10] unprivileged mounts: add sysctl tunable for
	"safe" property
Message-ID: <20080207153315.GB8701@skywalker>
References: <20080205213616.343721693@szeredi.hu> <20080205213705.120219893@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205213705.120219893@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 10:36:23PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add the following:
> 
>   /proc/sys/fs/types/${FS_TYPE}/usermount_safe
> 


There is  /proc/fs/<type>/ already. Since it is file system specific
shouldn't it go there ?

-aneesh
