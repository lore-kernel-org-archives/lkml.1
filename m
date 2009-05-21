Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380AbZEUJ4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbZEUJ4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZEUJ4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:56:13 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60554 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZEUJ4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:56:13 -0400
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
CC: jblunck@suse.de, bharata@in.ibm.com, vaurora@redhat.com,
       viro@zeniv.linux.org.uk
In-reply-to: <20090521092231.979256687@szeredi.hu> (message from Miklos
	Szeredi on Thu, 21 May 2009 11:22:31 +0200)
Subject: Re: [patch 0/5] union-directory implementation
References: <20090521092231.979256687@szeredi.hu>
Message-Id: <E1M750T-0005d4-Uq@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 21 May 2009 11:56:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009, Miklos Szeredi wrote:
> Features:
> 
>  - top level directory unification only
>  - no copy up
>  - no whiteouts, opaque dir, etc...
>  - create/rename/unlink only work on top layer
>  - write works on any layer (without copy up)
>  - directory entry deduplication in kernel
>  - supports directory seeking (that hell from POSIX)

Forgot an important one:

 - filesystem independent, any fs can be part of the union

Thanks,
Miklos
