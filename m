Return-Path: <linux-kernel-owner+w=401wt.eu-S1751737AbZKSGGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbZKSGGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 01:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZKSGGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 01:06:50 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:51478 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbZKSGGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 01:06:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=tWjD8M/BlVvkRNihalveUwZtxUn6A/PVf0TkdJewTX2SyAQVJPDyO3+j6kmYHVkzde
         d97BFAh2lROCQPYtpVao9r751fsSkSiQe9AhxOVbWnLe76ubaSPievO1DjO8AA+lF9MU
         oluYFTdOzGj9gm2dXQSylTxctJUhJqI4VE4pc=
Date: Thu, 19 Nov 2009 07:06:48 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Borislav Petkov <borislav.petkov@amd.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: manual merge of the edac-amd tree with the rr tree
Message-ID: <20091119060648.GA15404@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Borislav Petkov <borislav.petkov@amd.com>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Rusty Russell <rusty@rustcorp.com.au>
References: <20091119162354.8800a885.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091119162354.8800a885.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Nov 19, 2009 at 04:23:54PM +1100, Stephen Rothwell wrote:
> Today's linux-next merge of the edac-amd tree got a conflict in
> drivers/edac/amd64_edac.c because commit
> 4de1ce0c99ff838090d3b57cab8bc6eeb303dda5
> ("cpumask:amd64_edac-cpumask_t-remove") from the rr tree and commit
> 2fd9af91b92c10e58993f9eb70300fdff32698fb ("cpumask: use modern cpumask
> style in drivers/edac/amd64_edac.c") from the edac-amd tree are the same
> patch but there are further changes in the edac-amd tree.  So, Rusty, I
> guess you can drop that patch (unless something later in the rr tree
> depends on it).

yes, we agreed I should pick up this patch. Rusty?

-- 
Regards/Gruss,
    Boris.
