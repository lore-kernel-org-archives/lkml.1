Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbXL2Wyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbXL2Wyd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 17:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbXL2WyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 17:54:24 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:62892 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbXL2WyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 17:54:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZWCnzPuv1L59z8NoE08UhU3+ov4R7a4nLtjvYc+6ZdP4afNoA/Um+1wplAT+xhChQNz1yl0rdBNw0WCgSffccPKj/Berh1o9ImN5+KW1wtzkn7mH7cHf23rS4EhN872Pv1RWGrJM9vhNEnZLO5XZTCquHmxcvynBMkpVJFMitfQ=
Message-ID: <8b67d60712291454y6c60151cm7d9a4957e35adbfd@mail.gmail.com>
Date: Sat, 29 Dec 2007 22:54:22 +0000
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>
Subject: Re: [PATCH] Fix broken ip= parsing
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, horms@verge.net.au,
       davem@davemloft.net
In-Reply-To: <20071229170849.C2E68C2EEE@solo.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071229170849.C2E68C2EEE@solo.franken.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/12/2007, Thomas Bogendoerfer <tsbogend@alpha.franken.de> wrote:
> Commit a6c05c3d064dbb83be88cba3189beb5db9d2dfc3 breaks ip= parsing
> completly, because ic_enable is never set. The patch below puts
> back the way ic_enable was set before.
>
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
>
This patch certainly fixes the problem I was having with NFS root - I
had a working setup that stopped (though at the same time as I updated
my Busybox setup so I thought this was my mistake).

Please apply.

Tested by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
