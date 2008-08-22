Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbYHVTHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbYHVTHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYHVTHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:07:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:1279 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYHVTHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jRyjCBnv/aZloBQoZNLkNRAN8LcGiubWYWC5M3FehXHoz6T5iw1sjQQThrGSTxaTBY
         4nTHxv59O8TawG7aK4m+RdlKrEOtTjDSCsssH3ZRcD0PG7Cqp3nIQYDP+YCdNlAB1cqk
         1gR3V4fWUT4YMnVbpmdTshteNGTaJJGlXCdDw=
Message-ID: <86802c440808221207k726a7eb5p67e2333818fe4303@mail.gmail.com>
Date: Fri, 22 Aug 2008 12:07:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH] documentation: add more early_param boot options
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
In-Reply-To: <48AF0D4E.2030007@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AF0D4E.2030007@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 12:02 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Add some (more) early_param boot options to kernel-parameters.txt.
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  Documentation/kernel-parameters.txt |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> --- lin2627-rc4.orig/Documentation/kernel-parameters.txt
> +++ lin2627-rc4/Documentation/kernel-parameters.txt
> @@ -129,6 +129,13 @@ and is between 256 and 4096 characters.
>  ./include/asm/setup.h as COMMAND_LINE_SIZE.
>
>
> +       additional_cpus=  [IA-64,X86-32,X86-64]
> +                       Format: <int>
> +                       Specify the number of additional hotplug CPUs that
> +                       should be supported/allowed.  Can be used to
> +                       override BIOS info or to provide this info if not
> +                       already available.
> +
how about the one in Documentation/x86/x86_64/boot-options.txt ?

YH
