Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbYBNR7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbYBNR7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 12:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYBNR7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 12:59:33 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:8369 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbYBNR7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 12:59:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LZvP54ykK86ERzL9TuNOda/M75yjdCx1sQpWIpca8Qsoxx3SqlBob4p+8kKVKxij+CVQhkfQA5Wmg2cNLZeGHJa2HeYRZ2D852AC/Jc/b4+dH5qYuN+KVn2hsJuj/JWZjCQdeYefAipTqCdiTZ3CLNCIkkN6g7jEkTiggPrA27Q=
Subject: Re: [PATCH 05/11] ata: replace macro with static inline in libata.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <20080214120101.150a3284@core>
References: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
	 <1202966058.2748.19.camel@brick>  <20080214120101.150a3284@core>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 09:38:25 -0800
Message-Id: <1203010705.2748.46.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-14 at 12:01 +0000, Alan Cox wrote:
> On Wed, 13 Feb 2008 21:14:18 -0800
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > Avoid a metric ton of sparse warnings like:
> > drivers/ata/pata_ali.c:176:14: warning: symbol '__x' shadows an earlier one
> > drivers/ata/pata_ali.c:176:14: originally declared here
> 
> NAK that appears to be a sparse bug.
> 
> 1-4/6-10 Acked-by: Alan Cox <alan@redhat.com>
> 

No worries, for something like this it had better be obviously correct
or not applied.  I will try to come up with something more palatable.

Harvey

