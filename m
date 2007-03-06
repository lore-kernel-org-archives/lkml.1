Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbXCFByB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbXCFByB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 20:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933838AbXCFByA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 20:54:00 -0500
Received: from gw.goop.org ([64.81.55.164]:33067 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933832AbXCFByA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 20:54:00 -0500
Message-ID: <45ECC9B6.1060209@goop.org>
Date: Mon, 05 Mar 2007 17:53:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [patch] paravirt: VDSO page is essential
References: <20070305120631.GA14105@elte.hu>		<1173101297.26165.39.camel@localhost.localdomain>	<1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com>
In-Reply-To: <45ECC91D.1020809@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Jeremy Fitzhardinge wrote:
>> I think Jan's approach is better if it works (since there's no
>> compromise), but this is better if you want to get something working in
>> the near term.
>>   
>
> Is Jan dynamically relinking the vdso at runtime?  
Yes.  His patch adds a runtime relocation for the vdso.
http://marc.theaimsgroup.com/?l=xen-devel&m=117309332600075&w=2

    J
