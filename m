Return-Path: <linux-kernel-owner+w=401wt.eu-S1752153AbYJYNWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbYJYNWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 09:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYJYNWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 09:22:10 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:62561 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbYJYNWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 09:22:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=FHAgrwkXufhS2cuYzm3A8YiP6cWtALClX1RUgpywgyQYmzbmrYvZQmxecCOMeaLBGW
         IizlFMcnTUCaHGXK3sKcmaAIBqlyI+kWu+Gp3vE89RUnEMPeydlMMhS/Clqxnowya9AB
         Nw5L8a0DNPma1Ks1UNlHPatdZZzBMjwXen2Tw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: linux-next: Tree for October 24 - powerpc - build failure with !CONFIG_BLK_DEV_IDEDMA_PMAC
Date: Sat, 25 Oct 2008 15:19:57 +0200
User-Agent: KMail/1.9.10
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
References: <20081024171932.1e8131d0.sfr@canb.auug.org.au> <49024EA3.1080404@ru.mvista.com> <1224889818.7654.466.camel@pasglop>
In-Reply-To: <1224889818.7654.466.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810251519.57543.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 October 2008, Benjamin Herrenschmidt wrote:
> On Sat, 2008-10-25 at 02:39 +0400, Sergei Shtylyov wrote:
> > >>    Hm, looks like this configuration was never buildable --
> > #ifdef's are 
> > >> missing and wrongly placed. CCing Ben Herrenschmidt...
> > >>     
> > >
> > > What configuration ?
> > >   
> > 
> >    See the subject.
> 
> Ah ok. We should probably just remove the option...

Fine with me.  Anybody want an easy +1 patch-point? :)
