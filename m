Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbZGRDp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbZGRDp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 23:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757222AbZGRDp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 23:45:57 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:53319 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbZGRDp4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 23:45:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VP/3McAr7yBH1yD0Jxa51uspfNbP3eCWF97h6xEp59idL65jAU6n0w4MWcWuZ40Bll
         6DlXuCO5Hnba8vzWrtvoLBb9NzVu8LsSLLpGx1j7yzTmmj5jjJHluZTGuZ/TdlrAIeSI
         XpWVKDm1TJjrjl8BfsbmTeO69DcsapowRXXo8=
MIME-Version: 1.0
In-Reply-To: <20090717.101550.223298982.davem@davemloft.net>
References: <1247696049-15699-1-git-send-email-vapier@gentoo.org> 
	<20090716101957.GA9586@ioremap.net> <20090717.101550.223298982.davem@davemloft.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 17 Jul 2009 23:45:35 -0400
Message-ID: <8bd0f97a0907172045j2cff6987xb7ea0aab438bef9d@mail.gmail.com>
Subject: Re: [PATCH 1/3] connector: make callback argument type explicit
To: David Miller <davem@davemloft.net>
Cc: zbr@ioremap.net, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 13:15, David Miller wrote:
> From: Evgeniy Polyakov <zbr@ioremap.net>
>>
>> Your patches look good, thanks a lot.
>> David, please apply to the appropriate tree.
>
> Applied to net-next-2.6, but I am being very generous.
>
> In the future please make sure netdev@vger.kernel.org receives all
> networking patch postings so that they properly get tracked at:
>
>        http://patchwork.ozlabs.org/project/netdev/list/
>
> Otherwise they risk getting lost.

the fact that the connector code is maintained in the net tree is not
mentioned anywhere that i can see.  it isnt in net/, it isnt in
drivers/net/, and it isnt in MAINTAINERS.  that means anyone who
wishes to submit patches has to basically guess where to send them.
going by the default rules, that means the author (Evgeniy) and LKML.
expecting people to magically divine net ownership with this driver is
ridiculous.
-mike
