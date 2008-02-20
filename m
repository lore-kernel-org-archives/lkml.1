Return-Path: <linux-kernel-owner+w=401wt.eu-S1763892AbYBTARp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763892AbYBTARp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbYBTARe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:17:34 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:22300 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642AbYBTARc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:17:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YGjbDg35/YGBqnenvbTt+tqHHSGrb4Xv7eWjiuOqGU361AKaPW5mJg2vhkbnutQ0ZpBZlq+vfdNmsBV/EeS6qaA6O6w/5Dq7N6w2GTtfUXxquz32x2F9YsNs0DgeqVSltP6vM7HlGioo4IXy/PoDssAwhA3h0JVNI2HZh01Vm8w=
Message-ID: <a8e1da0802191617p7b5630a3mf017c9f0fdb52bc8@mail.gmail.com>
Date: Wed, 20 Feb 2008 08:17:31 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] bluetooth : put hci dev after del conn
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, netdev@vger.kernel.org
In-Reply-To: <20080218.204457.167455192.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080218075555.GA5940@darkstar.te-china.tietoenator.com>
	 <20080218.204457.167455192.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 12:44 PM, David Miller <davem@davemloft.net> wrote:
> From: Dave Young <hidave.darkstar@gmail.com>
> Date: Mon, 18 Feb 2008 15:55:55 +0800
>
> > Move hci_dev_put to del_conn to avoid hci dev going away before hci conn.
>
> This looks correct so I have applied it.
>
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>
> Please remove the extraneous space at the end of your
> signoff line next time :-)

Will do :)

>
> Also, I reworked the loop in del_conn() so that it no longer
> generates a compile warning, so I had to apply your patch
> by hand.
>

Thanks a lot.

Regards
dave
