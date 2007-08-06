Return-Path: <linux-kernel-owner+w=401wt.eu-S1764345AbXHFMed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764345AbXHFMed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 08:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbXHFMeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 08:34:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:25743 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbXHFMeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 08:34:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LtCE7fqec6uzHIcW+knPuHhKuaI1lfdIS7qtBRe2xMl9yC73QD16CogvNiKAjY1bWAFMQXUb0MaGS5n6MZRgS3a6D3HMq4labTahZkzLw2Z7bMdDKCb8++rRkvNdRZyjwRJDQM6Xy+xtTypsIL2J7SDFrgwiw2zbqOyywYoAdp0=
Message-ID: <b6a2187b0708060534r662f9507rdff51ffd650a74a0@mail.gmail.com>
Date: Mon, 6 Aug 2007 20:34:20 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.23-rc2
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>
In-Reply-To: <200708061326.25888.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0708052005550.3772@boston.corp.fedex.com>
	 <200708051847.12046.rjw@sisk.pl>
	 <b6a2187b0708051736u74879b9cp9e638364a5b1628e@mail.gmail.com>
	 <200708061326.25888.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/6/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> This means it's not in the whitelist, AFAICS.
>
> Similar machines are known to work with "--acpi_sleep=3" or with
> "--acpi_sleep=1 --vbe_mode".

Good news.

"s2ram --force --acpi_sleep 1 --vbe_mode" works.

I also tried "--acpi_sleep=3", but that doesn't work. Same
text-console messed up.


Tony, Peter, Linus, Rafael, thanks for all your help!!!

With this workaround, I'm all happy on 2.6.23-rc2.

If there's anything else you want to try, please let me know.

Thank you,
Jeff.
