Return-Path: <linux-kernel-owner+w=401wt.eu-S1030303AbXCLOyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030303AbXCLOyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030307AbXCLOyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:54:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:3272 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030303AbXCLOyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:54:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a0lq4zFhe4W8E1rJ0pQNPKc1LRQ7mMvmAgQxt6qz5mPwPtMqVSbNxswYWKbcIoodAGmTni54MXyR6A0gYxNwxKUzmVHxK5T4MBOyZU3iatUOvYAtrSMyUTCYGyCs1zPCSrkQgwD42Atc4ghKlCZxW//8VYOzalTwFk6OPf+Q7oE=
Message-ID: <2c0942db0703120754y13f4aa85g53bca542ec88100d@mail.gmail.com>
Date: Mon, 12 Mar 2007 10:54:18 -0400
From: "Ray Lee" <madrabbit@gmail.com>
Reply-To: ray-gmail@madrabbit.org
To: davids@webmaster.com
Subject: Re: RSDL-mm 0.28
Cc: "Matt Mackall" <mpm@selenic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, ck@vds.kolivas.org
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKAEBACDAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8cd998d50703101828l71fbec7bi9a819ad7b7fd9828@mail.gmail.com>
	 <MDEHLPKNGKAHNMBLJOLKAEBACDAC.davids@webmaster.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, David Schwartz <davids@webmaster.com> wrote:
> In no case is much of anything guaranteed, of course. (What can you do if
> there's no other process to yield to?)

Perhaps if sched_yield()'s effects were cumulative inside a timeslice,
then eventually the calling task would get pushed far enough down that
others would run.

Ray
