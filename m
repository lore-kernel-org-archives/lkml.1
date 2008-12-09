Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbYLIAHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbYLIAHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 19:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYLIAGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 19:06:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:24229 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbYLIAGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 19:06:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s/PIDKFpTwhcGKCWD53QCK+hfwV3coNPTSPpQWkmPhz4N5eX26ZTQSjr7C0dxE7j9p
         mIOa/yJyb+No0GmWUsXm/FjTrjBlekwpYR+s+Z0SFYU6OdgZMEf+INN8jOhejNPvUbBn
         BGazHaMOK9yfeAF8JWStkioJJxhcpSchxrT0Y=
Date: Tue, 9 Dec 2008 03:11:13 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       jmoyer@redhat.com, jens.axboe@oracle.com
Subject: next-2008-11-09: s390 vs ->ioctx_list
Message-ID: <20081209001113.GA6107@x200.localdomain>
References: <20081208205929.366a9a01.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081208205929.366a9a01.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      arch/s390/mm/pgtable.o
arch/s390/mm/pgtable.c: In function 's390_enable_sie':
arch/s390/mm/pgtable.c:266: error: invalid operands to binary ||
arch/s390/mm/pgtable.c:282: error: invalid operands to binary ||

This is because ->ioctx_list turned from pointer to a hlist, some more locking
and different check required.
