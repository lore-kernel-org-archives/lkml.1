Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbXEJKA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbXEJKA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbXEJKAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:00:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:58256 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbXEJKAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uOImHWgU8twG56BStBZeTM1bZPC4UCO1AH5o2jIUypIjVVYgZ1UmVq1m5BClh4ClSCHi+biLIfdWiZ1Y6N+kIDyT/TIIIZ8IbBWwg0oyPR2pBDhwCVuss3hRoxZ/bmgj6gKbH+WX+drKArL3SgLY+rR8rqTf1toAkrPeWeNIiZw=
Message-ID: <ac8af0be0705100300l91f8b38y288dad4b677bf188@mail.gmail.com>
Date: Thu, 10 May 2007 18:00:15 +0800
From: "Zhao Forrest" <forrest.zhao@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [discuss] A question about GART aperture unmap
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070510094908.GB14898@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac8af0be0705092259p65f057bcoe5e1b9abb963d5e3@mail.gmail.com>
	 <20070510094908.GB14898@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > As we know that CPU prefetch never cross the page boundary, in this
>
> That only applies to sequential prefetch. But speculative execution can
>  prefetch pretty much any address. That is why the clear_kernel_mapping is
> needed.

In BIOS setup, there's "Speculative TLB Reload". Is this "Speculative
TLB Reload" the same as your mentioned speculative execution?
After disabling "Speculative TLB Reload" in BIOS, we could also
experience sync flood and reset when commenting out
clear_kernel_mapping()......

Forrest
