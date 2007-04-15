Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbXDOKpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbXDOKpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 06:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXDOKpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 06:45:09 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:19324 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbXDOKpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 06:45:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TOphF7lCqtF77XzjbK48KXF9sUnl/rVuARvf/MTr9/pvYYhgvEEJC3H0dT9gL72okHdQx64auhHSnjfTpEZViGll76LHzzJGjNWJMPPWKh16w99GZYbo483YNj0s9Ge5No2kj8egraAq3FC8YtdI+ISIGvGVriSs1FakBsgGb6M=
Message-ID: <19061b0b0704150345h2bf6ad7el16d20a36c96f0ae9@mail.gmail.com>
Date: Sun, 15 Apr 2007 11:45:06 +0100
From: Bartek <poemann@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at net/core/skbuff.c in linux-2.6.21-rc6
In-Reply-To: <20070413.161635.26523891.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490704100425t34ebafcdq866a923df80b9aca@mail.gmail.com>
	 <19061b0b0704112218j13688c16xc755d66147f8fe6a@mail.gmail.com>
	 <461DC70B.4000500@trash.net>
	 <20070413.161635.26523891.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/4/14, David Miller <davem@davemloft.net>:
> From: Patrick McHardy <kaber@trash.net>
> Date: Thu, 12 Apr 2007 07:43:39 +0200
>
> > It seems we fail to reserve enough headroom for the case
> > buf[0] == PPP_ALLSTATIONS and buf[1] != PPP_UI.
> >
> > Can you try this patch please?
>
> Any confirmation of this fix yet?

I'm testing that patch, till now everything seems ok.

Regards
Bartek
