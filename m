Return-Path: <linux-kernel-owner+w=401wt.eu-S1761897AbXHOOSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761897AbXHOOSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbXHOOS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:18:29 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:12536 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbXHOOS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RqAtugdqOHL2fTN0Kt50x6wAvazzsEFlzWDw883g9bFpRD823ZY+HNYNP4K+uWz2oODedLIzk1nNEM4Xr5EBUC209NzHWkHFZ+VHRatkCV+QfRpXEMV7adV2SJzvoVxCRSk8BAKCdt0PYRFYGwm62C5RkCJlFlGRSvLr9508w+E=
Message-ID: <5d6222a80708150718v14f26343q7467385e7919fa76@mail.gmail.com>
Date: Wed, 15 Aug 2007 11:18:25 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 3/25][V3] irq_flags / halt routines
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <20070815135554.GE3406@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11871821854176-git-send-email-gcosta@redhat.com>
	 <1187182197314-git-send-email-gcosta@redhat.com>
	 <11871822062386-git-send-email-gcosta@redhat.com>
	 <11871822163867-git-send-email-gcosta@redhat.com>
	 <20070815135554.GE3406@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Didn't we agree this should be a pvops client?
>
> -Andi
>
No. I exposed my reasoning, asked you back, but got no answer.
I'll do it again:

This operations are just manipulating bits, and are doing no
privileged operations at all. Nothing that can be paravirtualized, in
the proper sense. Altough we do can introduce such operations for
clarity of code, I personally believe it is not the way to go.

What I did, then, was move this outside  the PARAVIRT ifdef, which
lead to a much cleaner code.



-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
