Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbZE1Piz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbZE1Piz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZE1Pis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:38:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:29410 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbZE1Pis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:38:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YgAE+zqgaUVaXbwpKgIrGgKAnDS669VP1FsYn52hi2ntbEpK4zlxwfo9SUOq3DcKQj
         IZ5QQPE7DIlGijaxokxRoXGWMP1KBAq3aWP/YQ8LU3EkvymeRcAWcv+kc+4cmftFqKsb
         0eAdYU3B0tJp2rBYRJ2unUoSHcMrnKCH2BL3k=
Date: Thu, 28 May 2009 19:38:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: akpm@linux-foundation.org, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/38] C/R: core stuff
Message-ID: <20090528153852.GC18256@x200.localdomain>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-18-git-send-email-adobriyan@gmail.com> <20090526131644.GA20920@hallyn.com> <20090526193503.GB11909@x200.localdomain> <20090526234436.GB23806@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526234436.GB23806@hallyn.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 06:44:36PM -0500, Serge E. Hallyn wrote:
> Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > And since you guys showed that just idea of in-kernel checkpointing is not
> > rejected outright, it doesn't mean that you can drag every single idea too.
> 
> Can you rephrase here?  I have no idea what you mean by 'drag every single
> idea'

  									complexity
 +-|------------------------------------------------|----------------------|-->
hypervisor C/R					in-kernel C/R	C/R for unpriviledged
								C/R with "leaks"

I personally thought in-kernel C/R will be rejected outright, but it wasn't.
This in theory doesn't mean other two issues should be accepted.
