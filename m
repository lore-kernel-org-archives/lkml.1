Return-Path: <linux-kernel-owner+w=401wt.eu-S1751183AbXCOKCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183AbXCOKCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 06:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbXCOKCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 06:02:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:45868 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbXCOKCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 06:02:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YszVheA8haUEOhImwJR6iYoDW7pki2J8Q4eGBRPKDcsQ6nkC0NwXYyWCAyj/+pnTXDZxy0A+G7NPEOXrt7Wp9S3+kiHgdSqwceZiP62pUmeV7TTTVx365s8ZNbdzvxRIZrwC9KHw4WxSOEKrYBZciX7CrtRMlf5QnA0kkHSrpq8=
Message-ID: <639c60080703150302u72d94370ka5f660f3599f91e1@mail.gmail.com>
Date: Thu, 15 Mar 2007 11:02:14 +0100
From: Nilshar <nilshar@gmail.com>
To: "Leroy van Logchem" <leroy.vanlogchem@wldelft.nl>
Subject: Re: [Bug 8040] Hang before INIT when CONFIG_HIGHMEM4G=y
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <loom.20070314T131349-236@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703141013.l2EADP6c027144@fire-2.osdl.org>
	 <20070314041710.770708c4.akpm@linux-foundation.org>
	 <6bffcb0e0703140430i2202f14dw1681d5c70c1d4e28@mail.gmail.com>
	 <loom.20070314T131349-236@post.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I can confirm that the problem disappear when I disable Compat VDSO
support by setting CONFIG_COMPAT_VDSO=n.

Thanks Leroy.
