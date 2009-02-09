Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbZBIKcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbZBIKcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZBIKcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:32:00 -0500
Received: from ozlabs.org ([203.10.76.45]:37340 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbZBIKb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:31:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/3] cpumask: fix powernow-k8: partial revert of 2fdf66b491ac706657946442789ec644cc317e1a
Date: Mon, 9 Feb 2009 21:01:53 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>, Yinghai Lu <yinghai@kernel.org>
References: <200902071809.39175.rusty@rustcorp.com.au> <20090209101723.GH20467@elte.hu>
In-Reply-To: <20090209101723.GH20467@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902092101.54193.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 February 2009 20:47:23 Ingo Molnar wrote:
> > -			goto err_out;
> > +			kfree(data);
> > +			return -ENODEV;
> >  		}
> 
> hm, why the 3-way duplication of this pattern:
> 
> > +			kfree(data);
> > +			return -ENODEV;
> 
> because it's a straight revert?

Yep, it reverts the changes to that one file.

Cheers,
Rusty.
