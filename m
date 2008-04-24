Return-Path: <linux-kernel-owner+w=401wt.eu-S1752589AbYDXIbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbYDXIbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 04:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbYDXIbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 04:31:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:39260 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbYDXIbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 04:31:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rf79kRuO3HMT+ajVe3kqpXISTN4lPS3d4Mz+d+s9nZkAKaprGERcHCgCvaA6QBPh4QKUOi00wb6O5zsTR2EfiGH9WAAq+F5YED0YCIV3ZNSbTYPmFmfU1v89nX0kTfTneQ+iu1R4WYeExjM8QJ36PJZ/AZiQ/3AVkjd8ZriH+i4=
Message-ID: <517f3f820804240131v3466713bi70d0eb0fb1f5cd8d@mail.gmail.com>
Date: Thu, 24 Apr 2008 10:31:15 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Samuel Thibault" <samuel.thibault@ens-lyon.org>,
       "Michael Kerrisk" <mtk.manpages@googlemail.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH,TRIVIAL] AF_UNIX, accept() and addrlen
In-Reply-To: <20080424001656.GM4825@implementation>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080308022321.GC5853@implementation>
	 <20080323.215641.192753003.davem@davemloft.net>
	 <20080324104330.GF4434@implementation.uk.xensource.com>
	 <87abko734d.fsf@basil.nowhere.org>
	 <20080324121719.GJ4434@implementation.uk.xensource.com>
	 <20080324122700.GK4434@implementation.uk.xensource.com>
	 <517f3f820803302100sdd50d71m4a990993f45e746c@mail.gmail.com>
	 <4808D1C5.8050304@gmail.com> <20080424001656.GM4825@implementation>
X-Google-Sender-Auth: c1574d3ca6d98496
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > and I see that in net/unix/af_unix.c::unix_getname() there is:
>  >
>
> >                 *uaddr_len = sizeof(short);
>
>  I'd say that code should be fixed into using sa_family_t.

Is there a patch for this?
