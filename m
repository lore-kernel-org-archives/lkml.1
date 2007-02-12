Return-Path: <linux-kernel-owner+w=401wt.eu-S933022AbXBLGtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbXBLGtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 01:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933039AbXBLGtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 01:49:47 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:60319 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022AbXBLGtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 01:49:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=q91j45hAfnp3K+SJ1xe2VB1GOaCGQIOrBa2ELInfElTdspD6u0rzo9iWIAXl2GEmCQwlJj8ymZsqmfeBKQoB1Fqee5Zw7An1rX/4nC+wN3vvkT2+wXxzH+ycVP+LXvGMAeEBfIEzBoHaowD1yoCQVSyr9sDUP787BV/IGFOn9pw=
Message-ID: <45D00DF7.6090605@gmail.com>
Date: Sun, 11 Feb 2007 22:49:27 -0800
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: ris <ris@elsat.net.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: High CPU usage with sata_nv
References: <20070115164541.M22367@elsat.net.pl> <20070115165432.M87238@elsat.net.pl> <20070115182642.GA18374@slug> <20070115222320.M55059@elsat.net.pl> <45B43241.1070301@gmail.com> <loom.20070211T232847-590@post.gmane.org>
In-Reply-To: <loom.20070211T232847-590@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ris wrote:
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  0  0      0 303444  53224 360132    0    0   276   157  627  814  5  2 89  4
>  0  0      0 302956  53228 360332    0    0   196     0 1193 1686  2  2 95  1
>  0  0      0 303204  53228 360332    0    0     0     0 1175 1544  2  1 97  0
>  1  0      0 234656  53240 428880    0    0 34428     0 1498 2532  4 11 69 16
>  2  0      0 105776  53248 556372    0    0 63752     0 1729 2696  6 18 47 29
>  0  3      0   9464  53248 648708    0    0 43780 28008 1804 2262  6 20 29 44
>  0  3   2588   9548  51548 647488    0    0 19200 47616 1503 1903  4  7 42 46
>  0  3   2640  10152  50840 648480    0    0 24716 11876 1695 2251  5  8  7 80
>  1  2   2640   9788  46468 652052    0    0 54280  5620 1740 2687  6 18  0 76
>  0  3   2640   9788  46308 652500    0    0 43392  2212 1626 2038  5 14  0 81
>  1  2   2640   9636  46308 653000    0    0 38528  1164 1588 2181  4 12  0 84
>  0  3   2640  13872  46084 648264    0    0 30088 12972 1701 2223  4 12  0 85
>  0  4   2644   8460  37140 661572    0 2640 25648 26372 1615 1908  3 10  0 88
>  0  3   2644   9188  16760 683196    0    0 33840 48988 1639 2154  4 12  0 84

iowait != cpu busy.  Your cpu idleness stays above 80%.

-- 
tejun
