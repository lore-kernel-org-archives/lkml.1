Return-Path: <linux-kernel-owner+w=401wt.eu-S1751801AbYJYThP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbYJYThP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 15:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbYJYTg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 15:36:58 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:34192 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYJYTg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 15:36:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=DGjbjE/cgQgwmdOosbsPuZDIjCDiZAiC4gVaJ+P0M4hOtf3Benfl1TgdlClMzOl7s7
         5wGHc3aMx3MnwN7Fmp+oCf65kn96FwZUzd8MNgd8yGWYP9c3l8M8uZGILxCEP2+V3IKI
         gOu7BYHKl2Bo6/xFqiQgktq6raVnBwEUozbe0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: linux-next: Tree for October 24 - powerpc - build failure with !CONFIG_BLK_DEV_IDEDMA_PMAC
Date: Sat, 25 Oct 2008 21:35:15 +0200
User-Agent: KMail/1.9.10
Cc: benh@kernel.crashing.org, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
References: <20081024171932.1e8131d0.sfr@canb.auug.org.au> <200810251519.57543.bzolnier@gmail.com> <49036C17.1060604@ru.mvista.com>
In-Reply-To: <49036C17.1060604@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810252135.16056.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 October 2008, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> >>>>>    Hm, looks like this configuration was never buildable -- #ifdef's are missing and wrongly placed. CCing Ben Herrenschmidt...   
> >>>>>           
> >>>> What configuration ?
> >>>>   
> >>>>         
> >>>    See the subject.
> >>>       
> >> Ah ok. We should probably just remove the option...
> >>     
> >
> > Fine with me.  Anybody want an easy +1 patch-point? :)
> >   
> 
>    BTW, why this option selects BLK_DEV_IDEDMA_PCI?

Leftover from the dark-ages...  needs fixing.
