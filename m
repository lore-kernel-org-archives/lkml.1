Return-Path: <linux-kernel-owner+w=401wt.eu-S1764793AbXHFMhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764793AbXHFMhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 08:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763876AbXHFMhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 08:37:33 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:42045 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433AbXHFMhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 08:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bgfscThAojMbBGANULTZYwC1bJU31K9/3mkvzyNu4ETxq4XzmBXIxqf0ZEza20drmoh1SqmjIlthy4ZE4HPKEzDU9vYI2WX9p7N92dv1F+snahJX2H5FqOfMbVAu3H1rBvvO2+Nj2OSkiCmJQhS4EEFYlo6TeWYBT42n2/fx5iw=
Message-ID: <b6a2187b0708060537h4bff040eqa5f0b2f22a5a728e@mail.gmail.com>
Date: Mon, 6 Aug 2007 20:37:25 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/3] 2.6.23-rc2: known regressions
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       Markus <lists4me@web.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       "Len Brown" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Plamen Petrov" <plamen.petrov@tk.ru.acad.bg>,
       "Denis Sadykov" <denis.m.sadykov@intel.com>, dth <dth@dth.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <46B5FA29.2070509@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B5FA29.2070509@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/6/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Unclassified
>
> Subject         : console is messed up after resume from s2ram or switching to console from X
> References      : http://lkml.org/lkml/2007/8/4/6
> Last known good : ?
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Caused-By       : ?
> Handled-By      : H. Peter Anvin <hpa@zytor.com>
>                   Antonino A. Daplas <adaplas@gmail.com>
> Status          : problem is being debugged

Thanks for Rafael for the workaround using "s2ram --force --acpi_sleep
1 --vbe_mode".
