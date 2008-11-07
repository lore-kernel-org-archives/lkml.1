Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYKGTFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYKGTFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbYKGTEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:04:54 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:6972 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbYKGTEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:04:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=a0diOXsPBwd9ATxynCwP4wPnt8ZfR8ZArusGdtHLJd4Fnj8Vs3/FZ/VUu66ZWxlDwT
         GNNUg9AahsrmXy7EpaFM7XmLxyXjYGZl2nPHZFbCGiUNj09bsnAWDACKYLQgIUVVHmtq
         OkTuD9QBkzreLc2LonCwBMbmN4FaFrXUz2bSc=
Subject: Re: [PATCH 1/5] adt7462: New hwmon driver
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
In-Reply-To: <20081107185626.13022.59407.stgit@elm3a70.beaverton.ibm.com>
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
	 <20081107185626.13022.59407.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 11:04:51 -0800
Message-Id: <1226084691.11596.42.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 10:56 -0800, Darrick J. Wong wrote:
> New driver to play with.  As Jean mentioned a couple of years ago,
> this
> chip is a beast with odd combinations of 8 fans, 4 temperatures, and 
> 13 voltage sensors.  This driver has been tested on an IntelliStation
> Z30.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> +#define MASK_AND_SHIFT(value, prefix)	\
> +	(((value) & prefix##_MASK) >> prefix##_SHIFT)
> +

I'm not sure, but doesn't this exist somewhere in the common kernel
headers.

> +#define ROUND_DIV(x, divisor)  (((x) + ((divisor) / 2)) / (divisor))

DIV_ROUND_UP ?

Harvey

