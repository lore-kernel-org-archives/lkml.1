Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbYEAJ4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbYEAJ4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 05:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758899AbYEAJzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 05:55:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:47061 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758794AbYEAJzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 05:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i34B3umA/bCpz2+CGId3kmWJWhkmtq4wgXE2EJamD/pb9eXJD6bySX2cjUZigQ1o+XRYjtIMPszd0f96avEmKg2J2PLqjpsq+QIjeWx9KVJbo7mi/ryaNjHkWfiPEffRgs0XcyaEGM9xG/XZFQ9n8xBebwZ1SyYuPTzFeEkWGs0=
Message-ID: <e2e108260805010255v6b728998i7d4952cc8fec28cb@mail.gmail.com>
Date: Thu, 1 May 2008 11:55:36 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH 1/1] Embedded Maintainer(s), linux-embedded@vger list
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       "Paul Gortmaker" <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Tim Bird" <tim.bird@am.sony.com>
In-Reply-To: <1209577483.25560.405.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1209577322.25560.402.camel@pmac.infradead.org>
	 <1209577483.25560.405.camel@pmac.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 7:44 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> Add Paul and myself, and the linux-embedded list, to MAINTAINERS.
>
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bca09ed..3650ed1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1550,6 +1550,14 @@ M:       raisch@de.ibm.com
>  L:     general@lists.openfabrics.org
>  S:     Supported
>
> +EMBEDDED LINUX
> +P:     Paul Gortmaker
> +M:     paul.gortmaker@windriver.com
> +P      David Woodhouse
> +M:     dwmw2@infradead.org
> +L:     linux-embedded@vger.kernel.org
> +S:     Maintained
> +
>  EMULEX LPFC FC SCSI DRIVER
>  P:     James Smart
>  M:     james.smart@emulex.com

It's great that more attention is being paid to the use of Linux in
embedded systems. And the MAINTAINERS file is probably the right file
to add the above information. But I'm afraid that the way the above
information is formatted will cause confusion. As an example, recently
there was a driver added to the Linux kernel for the PCF8575 chip.
This is an I2C chip that is only used in embedded systems. Regarding
driver review, should any such drivers be sent to the I2C mailing
list, the embedded mailing list or both ? The MAINTAINERS file should
be clear on this.

Bart.
