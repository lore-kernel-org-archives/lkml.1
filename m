Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbYAYTcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbYAYTcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 14:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYAYTcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 14:32:15 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:1387 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbYAYTcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 14:32:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D+IjrnIEGCzV/LEYqqYWaoONfJXTwtUQkrV2P1wH1/s+x/oubCzhf/LjBcn91zd41qRmzgBsjVwget1k46YJP0I38aciNhapMmn3Xvl5ZMMeqq7Tse/Khfo4GJN3m9bZzU7Ugns+QPiay3krWMGuJs44ofbLOmeMkMWC7e1zICM=
Message-ID: <86802c440801251132s463f5aceif33dbe46b6ff77a2@mail.gmail.com>
Date: Fri, 25 Jan 2008 11:32:13 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <479A3823.7000009@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47993F1A.5070408@goop.org> <200801241947.55223.yinghai.lu@sun.com>
	 <4799930B.40006@goop.org> <200801250042.53074.yinghai.lu@sun.com>
	 <20080125110935.GA20026@elte.hu> <479A30A3.7050305@goop.org>
	 <20080125185923.GA2518@elte.hu> <479A3222.30008@goop.org>
	 <20080125190418.GA7817@elte.hu> <479A3823.7000009@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25, 2008 11:27 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Ingo Molnar wrote:
> > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >
> >
> >> I was referring to:
> >>
> >> commit 6a4544a9c8b54b82893044cb53695502cc386f00
> >> Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
> >> Date:   Fri Jan 25 00:15:29 2008 +0100
> >>
> >>    x86_32: trim memory by updating e820 v3
> >>
> >> but you've answered the question...
> >>
> >
> > yeah, i guess what i've pushed out just now is v3++. Does it work for
> > you?
> >
>
> Yes, it does.  And for the record:
>
> [root@qemu ~]# cat /proc/mtrr
> [root@qemu ~]#

so the boot msg say:
WARNING: strange, CPU MTRRs all blank?

YH
