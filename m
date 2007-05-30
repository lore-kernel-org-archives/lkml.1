Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbXE3TXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbXE3TXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbXE3TXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:23:34 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:36447 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbXE3TXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:23:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cXJe5AHhQdTolhp7PjLOW6VyUPQYjFH1J09aWr0fAs7Qb5l9Qp6rD0nqR7z5M1Ztln4fNhE8kN/Dj80kshtBysvBFQzE5EY9AvPW23UtRkMwCfR1OAJNxYWTOrdbA/187yMt5f2EVferQMtE4qKH+0TyVnMXLKDTNcg4Q88eGiE=
Message-ID: <a781481a0705301223k1b52049eo33606cc158b00222@mail.gmail.com>
Date: Thu, 31 May 2007 00:53:20 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Roland Dreier" <rdreier@cisco.com>, openib-general@openib.org,
       linux-kernel@vger.kernel.org
Subject: Re: dealing with gcc 'comparison is always false' warnings (was: [PATCH] drivers/infiniband: fix comparsion between unsigned and negative)
In-Reply-To: <20070530190937.GA5444@nostromo.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070530080518.GA29195@nostromo.devel.redhat.com>
	 <adazm3mqqh3.fsf@cisco.com>
	 <a781481a0705300841k2a02335eg66985129eaed28f4@mail.gmail.com>
	 <20070530190937.GA5444@nostromo.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bill,

On 5/31/07, Bill Nottingham <notting@redhat.com> wrote:
> Satyam Sharma (satyam.sharma@gmail.com) said:
> > But yes, the kind of "fixes" you pointed out that _remove_ these conditions
> > are definitely *not* what we would want to do.
>
> I can see that - but I think it should be at least be brought up for each
> warning, to determine either:
>
> 1) if it should be ignored
> 2) if a signed type is actually intended
> 3) if the code should be elided

Agreed. The extract you've pointed out above was too strongly worded
unnecessarily / wrong generalization, and I corrected it later.

> While not necessarily in the IB instances, there are cases where there
> are entire blocks of code (with debugging output, error returns, etc)
> that can never get run, and it may make sense to remove those.

Agreed, again.

Satyam
