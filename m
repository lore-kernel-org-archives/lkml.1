Return-Path: <linux-kernel-owner+w=401wt.eu-S1759628AbXGEKQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbXGEKQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 06:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbXGEKQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 06:16:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:52969 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbXGEKQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 06:16:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gMyGneH0vW9gsr61GZ22uJxepqbrWjOUPO7lbyyK+Pf7GEHDzG2Yh7Nn+LNPfC/8zT6LAXP6QDi3XizKMDOxgi9Ysy0/zYYyJt72VATCDdzMdjdFQqMLdX7NiEHMPGiIoBLeEO+jd8bUHtzcndnhZLSdfGRZhirXpv4vChhN1IE=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH] Some love to default profiler
Date: Thu, 5 Jul 2007 12:16:28 +0200
User-Agent: KMail/1.8.2
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
References: <20070704213420.GA5864@martell.zuzino.mipt.ru> <9a8748490707041650s3b122007o46c8a34647b43af3@mail.gmail.com>
In-Reply-To: <9a8748490707041650s3b122007o46c8a34647b43af3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051216.29018.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 July 2007 01:50, Jesper Juhl wrote:
> > Removes conditional branch from schedule(). Code savings on my
> >    usual config:
> >
> >            text    data     bss     dec     hex filename
> >         2921871  179895  180224 3281990  321446 vmlinux         before
> >         2920141  179847  180224 3280212  320d54 vmlinux         after
> >         --------------------------------------------------------------
> >           -1730     -48           -1778
>
> Nice savings there. Not that 1.7K is huge, but it's kernel memory is
> precious :-)

Hehe. In busybox project people can kill for 1.7K :)
--
vda
