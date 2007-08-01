Return-Path: <linux-kernel-owner+w=401wt.eu-S1764958AbXHAPp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764958AbXHAPp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbXHAPpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:45:07 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:60062 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbXHAPpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:45:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gojl85MHFOD7DSZ/AEwXoxS0YkFEDjoltDUUpAdl9PGeRbjzW7h8J/Ra1EHKscwrDaHjnxqTBkozdVMV10bWMb4fv9kqmAXZexZ65b0EOhpW7Fk/8linS0OwMdv6boL9zdHWCNEFxl06uFI99EXraToY2VHLSQWGOOL68xI6YSE=
Message-ID: <29495f1d0708010845x446f7823qcfe2c5244b604078@mail.gmail.com>
Date: Wed, 1 Aug 2007 08:45:00 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: 2.6.22-rc1-mm1 huge pages VM freeze (maybe?)
Cc: "Zan Lynx" <zlynx@acm.org>, "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070731150245.5932b763.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1185918261.6981.13.camel@localhost>
	 <20070731150245.5932b763.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Tue, 31 Jul 2007 15:44:21 -0600 Zan Lynx wrote:
>
> > I was playing with huge pages and libhugetlbfs.  Small programs like
> > "ls" work fine.  I tried running Evolution through libhugetlbfs and the
> > system slowly stops running.  One interesting thing is the "ps" command,
> > it gets stuck like this:
>
> Do you mean 2.6.22-rc1-mm1 or 2.6.23-rc1-mm1?
>
> There was a hugepage problem fixed very recently, in 2.6.23-rc1 IIRC.

Actually fixed just after 2.6.23-rc1:

git describe 5ab3ee7b1cd5c91eb2272764f9d7d1fe4749681e
v2.6.23-rc1-14-g5ab3ee7

Thanks,
Nish
