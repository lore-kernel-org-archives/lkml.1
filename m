Return-Path: <linux-kernel-owner+w=401wt.eu-S1763562AbXGJKX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763562AbXGJKX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 06:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757900AbXGJKXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 06:23:18 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:35374 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576AbXGJKXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 06:23:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fH5G7/lHN7D6ktB71v+J9UxdRa+r/wQdSgqY6kbdm48AGJehn5/fMJZxI5h9PpW7cMdBB4XhIg6TDkAbfd+F8293z1ujE8ZRGBefxPiUKFc3sYoFxbdsRw+Kl02IoyD5RWhPM3KSoMBCvBvCx9yMbqIPQQ8C2McgCKFyz3fTefA=
Message-ID: <e9e943910707100323o35cb0316i5d3f21584ad8e4ae@mail.gmail.com>
Date: Tue, 10 Jul 2007 11:23:15 +0100
From: "Duane Griffin" <duaneg@dghda.com>
To: "Satyam Sharma" <ssatyam@cse.iitk.ac.in>
Subject: Re: [PATCH v2 -mm 8/9] netconsole: Support multiple logging targets
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Matt Mackall" <mpm@selenic.com>,
       "Keiichi Kii" <k-keiichi@bx.jp.nec.com>,
       Netdev <netdev@vger.kernel.org>, "Joel Becker" <joel.becker@oracle.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>
In-Reply-To: <20070710092001.23907.39876.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710091920.23907.96483.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <20070710092001.23907.39876.sendpatchset@cselinux1.cse.iitk.ac.in>
X-Google-Sender-Auth: ad9afa6cad1d08b8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/07, Satyam Sharma <ssatyam@cse.iitk.ac.in> wrote:
> +       /* Avoid taking lock and disabling interrupts unnecessarily */
> +       if (unlikely(list_empty(&target_list)))
> +               return;

Is the unlikely a good idea here? Not having any targets may be
unusual but it isn't ridiculous. It might even be a sensible default
for distros. My (very limited) understanding of unlikely is that it
could impose a very large penalty in that case and would make a very
marginal difference at best in the common case.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
