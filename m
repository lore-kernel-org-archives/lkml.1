Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbYEEC6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbYEEC6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 22:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYEEC6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 22:58:38 -0400
Received: from ag-out-0708.google.com ([72.14.246.247]:57541 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbYEEC6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 22:58:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gQ6uEnOoEk9+BpFILIQdgGG4qc/zccMVSbQ5bx2iMOsmxCBi6ewGDZDgn+gJsi+NWlQWwjqKeh5jEW0lvIpJFESPzxj2DtFxaVKAwEPE5s1d7BllgCddS17EcEFQTtb5/sNsVs4i5zsqVc42h7q4jAU0olgbC8vyyhOzTyAUCBE=
Message-ID: <a8e1da0805041958k30c03e20r6dd88f4135d6e5fe@mail.gmail.com>
Date: Mon, 5 May 2008 10:58:34 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH -mm] __ratelimit rewrite
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1209954305.13011.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080504070738.GA11832@darkstar.te-china.tietoenator.com>
	 <1209912447.16966.42.camel@localhost>
	 <a8e1da0805041837q4a5264c6l7bc23dce1d3282fd@mail.gmail.com>
	 <1209954305.13011.1.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2008 at 10:25 AM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2008-05-05 at 09:37 +0800, Dave Young wrote:
>  > >  I think your changes should then be done in
>  > >  printk.h not creating a new ratelimit.h.
>  >
>  > IMO ratelimit is not just for printk use now, so a standalone head
>  > file is necessary.
>
>  What other uses would ratelimit have?

ratelimit is a general function,  another user of it is
WARN_ON_RATELIMIT in this patch. It could have other usage in future.

>
>
