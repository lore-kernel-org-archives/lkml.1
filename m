Return-Path: <linux-kernel-owner+w=401wt.eu-S1763192AbXKQTKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763192AbXKQTKs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 14:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbXKQTKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 14:10:40 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:17697 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755424AbXKQTKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 14:10:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f6i+aQlhrBwALmeUuR1xqspGC+RlXErn5GlX1ADctZdaBRrLcx8JXdXPdqcp9d3L3ceLF0pXhqSg0dWTxWTJ1Y5HDm/XS0+V/qZgMxcI70d2Q0/koJNn6IEVuO4znxQyt+MKBwzQCIGaUeuCvQfu2aEiP8V+bP2ZxlJxn2KR/Dc=
Message-ID: <b647ffbd0711171110q9f695e1qb42ba73dc23b626d@mail.gmail.com>
Date: Sat, 17 Nov 2007 20:10:35 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Micah Dowty" <micah@vmware.com>
Subject: Re: High priority tasks break SMP balancer?
Cc: "Ingo Molnar" <mingo@elte.hu>, "Christoph Lameter" <clameter@sgi.com>,
       "Kyle Moffett" <mrmacman_g4@mac.com>, "Cyrus Massoumi" <cyrusm@gmx.net>,
       "LKML Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Mike Galbraith" <efault@gmx.de>,
       "Paul Menage" <menage@google.com>,
       "Peter Williams" <pwil3058@bigpond.net.au>
In-Reply-To: <20071117010352.GA13666@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0711151206370.28639@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0711151328090.29711@schroedinger.engr.sgi.com>
	 <20071115213510.GA16079@vmware.com>
	 <Pine.LNX.4.64.0711151830260.31691@schroedinger.engr.sgi.com>
	 <20071116024408.GA20322@vmware.com> <20071116060700.GD16273@elte.hu>
	 <b647ffbd0711160248v444d8f64ic72a17fcb56adc6d@mail.gmail.com>
	 <20071116221404.GC31527@vmware.com>
	 <b647ffbd0711161526p2faf5abt2457084f1996c735@mail.gmail.com>
	 <20071117010352.GA13666@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Micah,

ok, would it be possible to get "cat /proc/schedstat" output at the
moment when you observe the 'problem'? So we could try to analyze
behavior of the load balancer (yeah, we should have probably started
with this step)

something like this:

(the problem appears)
# cat /proc/schedstat

... wait either a few seconds or until the problem disappears
(whatever comes first)
# cat /proc/schedstat


TIA,

>
> --Micah
>

-- 
Best regards,
Dmitry Adamushko
