Return-Path: <linux-kernel-owner+w=401wt.eu-S933830AbXCFBwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830AbXCFBwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 20:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933832AbXCFBwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 20:52:07 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:48303 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933830AbXCFBwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 20:52:05 -0500
Message-ID: <45ECC91D.1020809@vmware.com>
Date: Mon, 05 Mar 2007 17:51:25 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [patch] paravirt: VDSO page is essential
References: <20070305120631.GA14105@elte.hu>		<1173101297.26165.39.camel@localhost.localdomain>	<1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org>
In-Reply-To: <45ECC076.9050209@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> I think Jan's approach is better if it works (since there's no
> compromise), but this is better if you want to get something working in
> the near term.
>   

Is Jan dynamically relinking the vdso at runtime?  Because that is what 
we will need.  Adding support for COMPAT_VDSO creates a major 
performance problem for us.  We need a way to force the VDSO to be 
enabled with a boot parameter.

Zach
