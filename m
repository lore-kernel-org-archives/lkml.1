Return-Path: <linux-kernel-owner+w=401wt.eu-S1030216AbXAXFpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030216AbXAXFpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 00:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030217AbXAXFpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 00:45:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:12379 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030216AbXAXFpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 00:45:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YQkiDCbduTR8yUnhLp1Q8RMMA0GRN6w6i+yslY3WUFp9mfUONbBy/cOkMNV4T2ImDNAVCxwJbPAqnU6HZupknLP+Do+1TBnKCEl+gtRWxVEbZFhmSiYwBhFeXGDe+NhGbHp5TxKJcxfRKMCfjaU4w00K4yU535XyUtS7c78vVaA=
Date: Wed, 24 Jan 2007 08:45:06 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, jaharkes@cs.cmu.edu
Subject: Re: [PATCH] seq_file conversion: coda
Message-ID: <20070124054506.GA5608@martell.zuzino.mipt.ru>
References: <20070115215305.GC5010@martell.zuzino.mipt.ru> <20070123165333.7c237a0e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070123165333.7c237a0e.akpm@osdl.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 04:53:33PM -0800, Andrew Morton wrote:
> On Tue, 16 Jan 2007 00:53:05 +0300
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > Compile-tested.
> 
> You can runtime-test this interface without ever having mounted a CODA fs.
> 
> Please.   compile-tested-only patches are always a worry.

OK, I've built coda. Patch doesn't change output of
/proc/fs/coda/{cache_inv_stats,vfs_stats}. Though I haven't mounted
filesystems.

