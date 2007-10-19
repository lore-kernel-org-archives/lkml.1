Return-Path: <linux-kernel-owner+w=401wt.eu-S1764825AbXJSP0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764825AbXJSP0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 11:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbXJSP0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 11:26:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:16294 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbXJSP0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 11:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jPoKcjQX/C8E2hmqyHaH0H+LIGZ3/cU1EL2fFXNjd9I+YSE3H7Q21ZaYcPkfKzjXdpGtx6XOOSvWp53rZIC/DIlT7uWYMxBD/j2latmrnEBW64LQvn09MRaN0OW6Q4JkxvRNx+GInyykuK11zd5fviZEm2oru4MTjLQ3XCwzBL0=
Message-ID: <35fbaa3e0710190826uae4e7b7u7d8f3139e1697030@mail.gmail.com>
Date: Fri, 19 Oct 2007 18:26:35 +0300
From: "Vitaliy Ivanov" <vitalivanov@gmail.com>
To: w@1wt.eu
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
Cc: zaitcev@redhat.com, gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, vitalivanov@gmail.com
In-Reply-To: <1192644776.10761.60.camel@dell1.softservecom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192383445.8372.18.camel@dell1.softservecom.com>
	 <20071014182542.GA2832@1wt.eu>
	 <35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com>
	 <20071014223921.GA4677@1wt.eu>
	 <1192542889.29039.66.camel@dell1.softservecom.com>
	 <20071016154138.GA23326@1wt.eu>
	 <1192559051.29039.139.camel@dell1.softservecom.com>
	 <1192644776.10761.60.camel@dell1.softservecom.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/07, Vitaliy Ivanov <vitalivanov@gmail.com> wrote:
> Willy & Pete,
>
> On Tue, 2007-10-16 at 21:24, Vitaliy Ivanov wrote:
> > Following Pete notes I will rework code and give it for review once again.
> > As I said it's usb-skeleton approach that I reused during the port.
> >
> > Anyway, will get back to this soon.
>
> Reworked code a little.
>
> Issue with locks...
> Now minor_table_mutex is used to protect the minor_table structure and nothing else.
> It was its first purpose.
>
> dev->sem is used to protect device manipulations. It's a normal practice in 2.4.
> So I leave it this way. I think it's OK, Pete?
>
> So the final patch, hope it's final, no?:)
>
> P.S. Willy all the details you asked before can be found in my previous mail(description, device list, etc).
>

Hi all,

Didn't here anything on this? What is our final decision here?

Thanks,
Vitaliy
