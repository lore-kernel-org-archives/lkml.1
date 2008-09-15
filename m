Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbYIOLpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbYIOLpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 07:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbYIOLpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 07:45:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:35118 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbYIOLpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 07:45:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ws5h3FUVL7nXXxrKr3kuIBZXE+Wj36fClGRH1PNrYxQGpC9KEM81l9lpDtx2hhavfA
         JWEYH3R02S22T5jWKanpsT753h0HBo/WQ4BH2E6NcNXOAr4CtE8sHbw0gNpP8GaPwM5f
         GxnGjfVXB1WcjfLwHgXd8nmz5M5V2uLjB74gA=
Message-ID: <d6c8ef150809150445qbd16c5ap7923468008477705@mail.gmail.com>
Date: Mon, 15 Sep 2008 13:45:17 +0200
From: "Bosko Radivojevic" <bosko.radivojevic@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: GRE keepalives, again
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20080914.170302.132520341.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d6c8ef150809141549m52289f1cr7b4da508b311af1f@mail.gmail.com>
	 <20080914.170302.132520341.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 2:03 AM, David Miller <davem@davemloft.net> wrote:
> netdev@vger.kernel.org is where networking developers are, added
> to the CC:

Thanks for that!

>> this, and it looks like inner packet never leave ip_gre code. It looks
>> like the journey of the packet ends in  ipgre_ecn_decapsulate() at the
>> very beginning:  if (INET_ECN_is_ce(iph->tos)) {

This one here is not true. I'll keep digging, but I think that this
behavior is not result of a bug. It seems I just don't know how to
turn the feature off ;)

Sincerely,
Bosko
