Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbXKZKYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbXKZKYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 05:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbXKZKXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 05:23:51 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:14926 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbXKZKXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 05:23:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F4/p4XrPILP+gkG4ziy0c2QVxxflB/8FbsvIWJzKSXTua6REWi0H2+F78nMtxuSTIHxu2C1KhSxxyXFYyabI+ujk5Cvaq2MwkbUBTO1UIWFVzYPsn3WBEEWpFg2DPgo5JzDpoQkEMbh+YF4tu0QRHBk6XW7+3oPUHpdXpu/XZuw=
Message-ID: <b25c3fa70711260223w5a15bb1bk4652b3ab8f05c40c@mail.gmail.com>
Date: Mon, 26 Nov 2007 19:23:48 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [PATCH 4/4] atm/ambassador: kmalloc + memset conversion to kzalloc
Cc: netdev@vger.kernel.org, chas@cmf.nrl.navy.mil,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.9999.0711260409110.551@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <007f01c8300b$1b89ac40$9c94fea9@jason>
	 <alpine.LFD.0.9999.0711260409110.551@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/11/26, Robert P. J. Day <rpjday@crashcourse.ca>:
> i'm not sure the above is a safe thing to do, as you're zeroing that
> area, then making a function call and assuming, upon entry to the
> function call, that the caller has done the right thing.  i don't see
> how you can count on that, depending on who else might want to call
> that routine and whether they get sloppy about it.  unless you're
> prepared to guarantee that there will never be another call to
> setup_dev() from elsewhere.
>

Thanks for your response.
But setup_dev is static function and only amb_init calls it.
IMO it's safe.

Thanks.
Joonwoo
