Return-Path: <linux-kernel-owner+w=401wt.eu-S1752142AbXCYMDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbXCYMDn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 08:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXCYMDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 08:03:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:55992 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbXCYMDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 08:03:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j+eBZEzwJRIMeI72KNo5UJImRbhP2YJ8JaPOad3nLl9Jd5dhqxxxkju9YN+zUq3d2/aw/UbQH6b0KEdWPyQ4aL/yHA7Y1DsD5Z3ZqcxFtRjnueA5y1TyZjHqTbBbuBbJnI6hCi4XverCDBia8FtHszjFJuB8+rdez2J7+5xT+Uc=
Message-ID: <1a297b360703250503g1a973e70ycd0f7a683982b228@mail.gmail.com>
Date: Sun, 25 Mar 2007 16:03:38 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] DVB: Delete unused header file linux/dvb/version.h.
Cc: "Marcel Siegert" <mws@linuxtv.org>, "Andrew Morton" <akpm@osdl.org>,
       v4l-dvb-maintainer@linuxtv.org,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1174813880.1158.297.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703231130480.30201@CPE00045a9c397f-CM001225dbafb6>
	 <200703231647.53780.mws@linuxtv.org>
	 <1174665764.1158.241.camel@laptopd505.fenrus.org>
	 <1a297b360703240504u2c9e705m5601d150f15e3c45@mail.gmail.com>
	 <1174813880.1158.297.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/07, Arjan van de Ven <arjan@infradead.org> wrote:
>
>
> > There are cases where we need an API update since newer systems do show up.
> > In such a case, the only way is to provide backward compatibility
> > while adding in newer stuff.
> >
> > Currently we use the version major/minor for the userspace to identify
> > the in kernel API, while the userspace apps can remain binary
> > compatible
>
> this is the problem exactly! Your userspace binary knows about the
> kernel headers it was compiled against, not about the actual running
> kernel! They are very likely not the same.

Well, we could go for an IOCTL in such a case to avoid the unpleasant scenario.


Manu
