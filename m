Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbYKGJcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbYKGJcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYKGJcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:32:43 -0500
Received: from acsinet14.oracle.com ([141.146.126.236]:57853 "EHLO
	acsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbYKGJcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:32:42 -0500
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2008 04:32:42 EST
Date: Fri, 7 Nov 2008 01:23:14 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Michael Trimarchi <trimarchimichael@yahoo.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Check if the Hangcheck-timer TSC source is stable
Message-ID: <20081107092314.GI15220@mail.oracle.com>
Mail-Followup-To: Michael Trimarchi <trimarchimichael@yahoo.it>,
	linux-kernel@vger.kernel.org
References: <491371A8.3090603@yahoo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491371A8.3090603@yahoo.it>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: acsinet12.oracle.com [141.146.126.234]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4914099F.009C:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 11:37:28PM +0100, Michael Trimarchi wrote:
> Check if the TSC source is stable otherwise fail registration.

	Good idea.

> @@ -151,8 +155,10 @@ static void hangcheck_fire(unsigned long data)
>  
>  	if (cur_tsc > hangcheck_tsc)
>  		tsc_diff = cur_tsc - hangcheck_tsc;
> -	else
> -		tsc_diff = (cur_tsc + (~0ULL - hangcheck_tsc)); /* or something */
> +	else {
> +		/* or samenthing */
> +		tsc_diff = (cur_tsc + (~0ULL - hangcheck_tsc));
> +	}

	This hunk isn't any good.  The comment spelling is messed up,
and really you can just remove the "or something".

Joel

-- 

"There is no sincerer love than the love of food."  
         - George Bernard Shaw 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
