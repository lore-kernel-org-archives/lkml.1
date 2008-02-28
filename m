Return-Path: <linux-kernel-owner+w=401wt.eu-S1759442AbYB1Brj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbYB1Brj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbYB1Brb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:47:31 -0500
Received: from namei.org ([69.55.235.186]:49168 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753179AbYB1Bra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:47:30 -0500
Date: Thu, 28 Feb 2008 12:46:56 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/11] NFSD: Server implementation of MAC Labeling
In-Reply-To: <1204150294-4678-12-git-send-email-dpquigl@tycho.nsa.gov>
Message-ID: <Xine.LNX.4.64.0802281245550.27221@us.intercode.com.au>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
 <1204150294-4678-12-git-send-email-dpquigl@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, David P. Quigley wrote:

> +
> +	if (len > NFS4_MAXLABELLEN) {
> +		err = nfserrno(len);
> +		goto out_err;
> +	}

In this case, len is not an errno and should not be passed to nfserrno().


- James
-- 
James Morris
<jmorris@namei.org>
