Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbXJSPnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbXJSPnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 11:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbXJSPnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 11:43:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:20084 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbXJSPnN (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 11:43:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ED2oFL/68w24njanvjick+Q4Yr1m7YlQjxxbquW1aYWAe/EFVSSHpLNolnCmlQuByRss1HDAMX7ELyobL8PY+1RjNZVavSRcO2uxhv4cjmhN04BUIv/xDS2ojr9qKpb4Ir0lvkAXtJCC50Ek08oiyRYGrnmGUFU0Y2naVAzS+sA=
Message-ID: <68676e00710190843l740698ffv478375665773263@mail.gmail.com>
Date: Fri, 19 Oct 2007 17:43:06 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Christian Borntraeger" <borntraeger@de.ibm.com>
Subject: Re: [kvm-devel] severe bug in 2.6.23+ kvm.git
Cc: "Laurent Vivier" <Laurent.Vivier@bull.net>, carsteno@de.ibm.com,
       "Mike Lampard" <mike@secnet.net.au>, Linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Aurelien Jarno" <aurelien@aurel32.net>
In-Reply-To: <200710191723.48104.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47189371.7080104@de.ibm.com>
	 <200710191648.32157.borntraeger@de.ibm.com>
	 <4718C5E0.9000204@bull.net>
	 <200710191723.48104.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/07, Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> Am Freitag, 19. Oktober 2007 schrieb Laurent Vivier:
> > Did you patch kvm.git with patch-2.6.23.1.bz2 or did you download
> > linux-2.6.23.1.tar.bz2 ?
> >
> > 2.6.23.1 corrects nothing except sata_mv...
>
> Yes I know. The question we tried to answer was: is the bug in 2.6.23 or was
> it introduced after 2.6.23, as kvm.git  already contains lots of post 2. 6.23
> stuff.
> Current state is:
>
> kvm.git with tag 2.6.23-rc6 works for days without a problem.
> 2.6.23.1 vanilla has survived and is currently still under test.
> kvm.git tag master killed our filesystem at least three times.since monday.

linus-git has at least one bug with SG chaining, but usually it just
hangs the machine. Patch is here:

http://lkml.org/lkml/2007/10/17/269

Luca
