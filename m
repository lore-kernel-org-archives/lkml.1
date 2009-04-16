Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbZDPRzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbZDPRzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 13:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbZDPRzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 13:55:38 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:47830 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755845AbZDPRzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 13:55:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=2PPjqU1foo3IPNVDLFEB8a1UrADEyF47YWOIu8wcAUyyXscSZ+GwiRm2YNVlOSh/PEbFmTGciVobm6PzstXWu0b3PYz4rxOjAwYLV5YGd5Zb9JbSVzFPvFDpxVI/u8XYrToZf5DSXd58SP48azrCp9htU80igV8+w9F49PJYgNs=  ;
X-YMail-OSG: 2jBFxagVM1m2BuAZw4Nx8S.eyLMLSe8wdxJSi5RQbD6bzbfYzQLkym9xlzr0Ll91RiC9DJ8Rs.XRDrnw_6q1bqTWLEHr7f1zmdy5KPXddFJ4UEvjv_34m6W.zV..lZjnbDQOa7g6HwVfbC_pXH46.odA1jwNKARh7M8cwAnzDcFQflFMLMDYaJJYzYT7gv73XYPmDfdKCz_nxVq.TPr0SHxnCwvy413RxyIGSiSgInIgDBUsjBHH13d0np.CGr1_CzheBi9bPrY.nsOvsrSvNysCAdhaDBEd7DI7E4MzHAj5hVEaNwMsetRXpe5XNizxMnaBbxh1jJyOeJ.X8NSrv2M-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux v3
Date: Fri, 17 Apr 2009 03:55:24 +1000
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       aarcange@redhat.com, chrisw@redhat.com, mtosatti@redhat.com,
       hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com
References: <1239249521-5013-1-git-send-email-ieidus@redhat.com> <20090414150903.b01fa3b9.akpm@linux-foundation.org>
In-Reply-To: <20090414150903.b01fa3b9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904170355.26294.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 April 2009 08:09:03 Andrew Morton wrote:
> On Thu,  9 Apr 2009 06:58:37 +0300
> Izik Eidus <ieidus@redhat.com> wrote:
> 
> > KSM is a linux driver that allows dynamicly sharing identical memory
> > pages between one or more processes.
> 
> Generally looks OK to me.  But that doesn't mean much.  We should rub
> bottles with words like "hugh" and "nick" on them to be sure.

I haven't looked too closely at it yet sorry. Hugh has a great eye for
these details, though, hint hint :)

As everyone knows, my favourite thing is to say nasty things about any
new feature that adds complexity to common code. I feel like crying to
hear about how many more instances of MS Office we can all run, if only
we apply this patch. And the poorly written HPC app just sounds like
scrapings from the bottom of justification barrel.

I'm sorry, maybe I'm way off with my understanding of how important
this is. There isn't too much help in the changelog. A discussion of
where the memory savings comes from, and how far does things like
sharing of fs image, or ballooning goes and how much extra savings we
get from this... with people from other hypervisors involved as well.
Have I missed this kind of discussion?

Careful what you wish for, ay? :)
