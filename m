Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbYKHDiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbYKHDiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 22:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYKHDiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 22:38:08 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:33471 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbYKHDiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 22:38:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PXjSRm0u1f9GKmCnKhKRC4dE0ZIdiI1tNcpsUViY8QdiSBVSsLUKiuBBpvZ2f+sFc2
         acPWG8mK5wI4WZDDN++fU9U7XQhaQV3u4OfNeqIvhEkS243HYvRmzZHXQ9Cj0Ms0HIJZ
         ncwPqfE+4kBzROw0hn4n8uCVQgvfZ6xmVbAys=
Subject: Re: [PATCH 10/10] xtensa: use the new byteorder headers - Merged
 with your previous xtensa-next and will remerge shortly.
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Piet Delaney <piet.delaney@tensilica.com>
Cc: Chris Zankel <chris@zankel.net>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Marc Gauthier <marc@tensilica.com>,
       Joe Taylor <joetayloremail@gmail.com>, linux-xtensa@linux-xtensa.org,
       Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <491500C0.90407@tensilica.com>
References: <1225910131.5991.230.camel@brick> <49133094.6070407@zankel.net>
	 <491500C0.90407@tensilica.com>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 19:38:01 -0800
Message-Id: <1226115481.11596.63.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 19:00 -0800, Piet Delaney wrote:
> Hi Chris:
> 
>    I've merged your recent xtensa-next with our 2.6.24-smp repo.
> It seems to work fine and I'm in the process of cleaning it
> up a bit and adding preliminary XTENSA kgdb support.

2.6.24?  In that case you probably don't have include/linux/byteorder.h,
or include/linux/swab.h which would explain your byteorder problems.

Or is that a typo in the version numbers?

You should be able to just pull those two headers from Linus' tree
and drop them in, there is no dependencies other than those two
headers.

If it is some other problem, let me know and I'll look into it.

Harvey

