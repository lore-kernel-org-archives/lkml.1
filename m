Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbYH3SHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbYH3SHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 14:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbYH3SHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 14:07:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:40802 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbYH3SHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 14:07:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IegzaGhYsD0dmwcAfx+018TiRS0qIHxgrCNkivMEvJyfgL75OyXZMNtKLunaH4IKGj
         FcpRbgoCgoOqSkkNVBKRsEMjyzBgf50xUZ5xD6uTUV7j4G9Ds0cJaPaah4XlouxpGQUd
         ho1nrEqk47Xy4VriJN6KkvG1OpnOpydnOVQh0=
Message-ID: <86802c440808301107n4561e815ldf53183c92a7bc93@mail.gmail.com>
Date: Sat, 30 Aug 2008 11:07:22 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808301012060.3290@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <200808292157.24179.rjw@sisk.pl>
	 <alpine.LFD.1.10.0808291434110.3300@nehalem.linux-foundation.org>
	 <200808300030.32905.rjw@sisk.pl>
	 <alpine.LFD.1.10.0808301012060.3290@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 10:39 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

>
> What _broke_ for you is that the horrible patch that got reverted said
> that "if we recognize this as an MCFG resource, we will _always_ try to
> insert it", so it fundamentally broke the whole resource tree, because it
> force-inserted that totally crap resource.

again, should use MCFG end as the res _end

YH
