Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbYC1Isb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbYC1Isb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 04:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbYC1IsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 04:48:20 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:7773 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYC1IsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 04:48:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TqIldFr/JGuwBO0tBdK0jom2oWXPwBi32av4shF9W4FhAGNRQCod9KiW1LqcTxfZuG2k5LtQmhMegi1dgjCMs8adH81Q/8Qy5hZzM18TzQavZxP0PHSPB1uo/3RbFowja8234SkblxQJY15EcTzL7din6LoIa46G9DbC0pXuS/g=
Message-ID: <aec7e5c30803280148m3397fb40p192c9cbafe4f0838@mail.gmail.com>
Date: Fri, 28 Mar 2008 17:48:18 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH] test for NULL return from platform_get_resource() in ohci_hcd_sm501_drv_remove()
Cc: "Jesper Juhl" <jesper.juhl@gmail.com>, linux-usb@vger.kernel.org,
       "Roman Weissgaerber" <weissg@vienna.at>,
       "Lennert Buytenhek" <kernel@wantstofly.org>, "Greg KH" <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200803271227.46818.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.00.0803212250210.9597@dragon.funnycrock.com>
	 <200803271227.46818.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 4:27 AM, David Brownell <david-b@pacbell.net> wrote:
> On Friday 21 March 2008, Jesper Juhl wrote:
>  >
>  > platform_get_resource() may return null, so although it seems it will never
>  > do so here unless there's a bug elsewhere, it does no harm to be defensive
>  > and test.
>  >
>  > Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
>
>  Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Magnus Damm <magnus.damm@gmail.com>
