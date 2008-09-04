Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbYIDPB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbYIDPB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYIDPBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:01:50 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52930 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbYIDPBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:01:50 -0400
Subject: Re: [RFC v3][PATCH 8/9] File descriprtors (dump)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <Pine.LNX.4.64.0809040405250.5982@takamine.ncl.cs.columbia.edu>
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0809040405250.5982@takamine.ncl.cs.columbia.edu>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 08:01:44 -0700
Message-Id: <1220540504.23620.40.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 04:05 -0400, Oren Laadan wrote:
> 
> diff --git a/include/linux/ckpt_hdr.h b/include/linux/ckpt_hdr.h
> index 322ade5..1ce1dbc 100644
> --- a/include/linux/ckpt_hdr.h
> +++ b/include/linux/ckpt_hdr.h
> @@ -17,7 +17,7 @@
>   /*
>    * To maintain compatibility between 32-bit and 64-bit architecture flavors,
>    * keep data 64-bit aligned: use padding for structure members, and use
> - * __attribute__ ((aligned (8))) for the entire structure.
> + * __attribute__((aligned(8))) for the entire structure.
>    */

Have you tried emailing these to yourself and trying to apply them?
That's usually a good way to iron out these whitespace issues.

I think this set is still munged.

-- Dave

