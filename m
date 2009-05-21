Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbZEUADS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbZEUADS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbZEUADL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:03:11 -0400
Received: from web50104.mail.re2.yahoo.com ([206.190.38.32]:21492 "HELO
	web50104.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754760AbZEUADL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:03:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=FQeIz9HZD2ve7zs3EnGX3xI6LEdOjF1k4U4wXJ6weBT+3ykbuns1NKV+nQ3Okj/8/UthHKC/r41IExPpmEm2a3eZnSGWT8mMRRBaS9vfnv/RXJ5xgnPgQYWxP6OcIw65rbxOYxmiCgIO7T8bhe/58LL0QTGrTniQ/CGWa700pd8=;
Message-ID: <341053.98503.qm@web50104.mail.re2.yahoo.com>
X-YMail-OSG: Q6N3G1YVM1mWTsAvikaqxBAeq3XXTBJN3_ROJqGWh.jsFL15.9hvBzO0NoQnmnl4XHJj7DG0b0zYtuVLsnWjV9fp_xFHVv3z6hNBtWGqOUvSY3ie3BPNXyqMelF1uj6sCwlG3pO7E0LP6Z8Bh71PZmG0DhQ.HnUzwxRqSkISx04uk_EiYKy8yRF2eiNK2FbLSCECcGMlfizTRLLjLNfBWiWn.3x86w_noV2DhZ_1iNVgUCewoILHWirMExM7mUerjjy35Y1fMbDbE2v39cEqV3SShqFo0oCyXpRf1sXwolHrEk49YGQ4GBvXTt64dEw-
X-Mailer: YahooMailClassic/5.4.6 YahooMailWebService/0.7.289.10
Date: Wed, 20 May 2009 17:03:12 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 2/4] amd64_edac: do not enable module by default
To: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       Borislav Petkov <borislav.petkov@amd.com>
Cc: tglx@linutronix.de, hpa@zytor.com, mchehab@redhat.com, aris@redhat.com,
       edt@aei.ca, linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       Borislav Petkov <borislav.petkov@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Wed, 5/20/09, Borislav Petkov <borislav.petkov@amd.com> wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> Subject: [PATCH 2/4] amd64_edac: do not enable module by default
> To: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu
> Cc: norsk5@yahoo.com, tglx@linutronix.de, hpa@zytor.com, mchehab@redhat.com, aris@redhat.com, edt@aei.ca, linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, "Borislav Petkov" <borislav.petkov@amd.com>
> Date: Wednesday, May 20, 2009, 12:43 PM
> While at it, fix a link failure when
> !K8_NB.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Acked-by: Doug Thompson <dougthompson@xmission.com>

> ---
>  drivers/edac/Kconfig |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 1c5a325..d294421 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -60,11 +60,10 @@ config EDAC_MM_EDAC
>  
>  config EDAC_AMD64
>      tristate "AMD64 (Opteron, Athlon64) K8,
> F10h, F11h"
> -    depends on EDAC_MM_EDAC && X86
> && PCI
> -    default m
> +    depends on EDAC_MM_EDAC &&
> K8_NB && X86_64 && PCI
>      help
> -    Support for error detection and
> correction on the AMD 64
> -    Families of Memory Controllers (K8,
> F10h and F11h)
> +      Support for error detection and
> correction on the AMD 64
> +      Families of Memory Controllers
> (K8, F10h and F11h)
>  
>  config EDAC_AMD64_ERROR_INJECTION
>      bool "Sysfs Error Injection
> facilities"
> -- 
> 1.6.2.4
> 
> 
> 
