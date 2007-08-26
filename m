Return-Path: <linux-kernel-owner+w=401wt.eu-S1751899AbXHZKEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbXHZKEV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 06:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbXHZKEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 06:04:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:44415 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbXHZKEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 06:04:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p4SvzFa8lcOfg3St8Cimmc5GMqKJOjB3XqTctdDTC/oHZqBuLb+6nXxhCMuGtXdO4HdlbiTu5nzyf+1mhit0ITlsNBewvnohg1OJt/eInr1P/JdLD8f9xgmpB5Vvpv2i5q4s3Xq/36+f4EfAEkEqGfZxPZXeX7e+PZnBw/sGkjk=
Message-ID: <a2ebde260708260304y40394ea9jb6065a51f789ca3f@mail.gmail.com>
Date: Sun, 26 Aug 2007 18:04:06 +0800
From: "Dong Feng" <middle.fengdong@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: 2.6.22.5 SATA Failure
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <46D1013D.5040801@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.9lnv231u8AU5Nlw9OFEhJs+u+Yw@ifi.uio.no>
	 <46D1013D.5040801@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/26, Robert Hancock <hancockr@shaw.ca>:
>
> It looks like you have some CONFIG_IDE options enabled in your kernel
> configuration that result in drivers/ide trying to drive part or all of
> that controller, preventing libata from doing so. Likely the easiest
> thing to do is just set CONFIG_IDE=n entirely..
>
> --
> Robert Hancock      Saskatoon, SK, Canada
> To email, remove "nospam" from hancockr@nospamshaw.ca
> Home Page: http://www.roberthancock.com/
>
>

The SATA works with 2.6.22.5 after CONFIG_IDE =n being set.

Thank you very much.
