Return-Path: <linux-kernel-owner+w=401wt.eu-S1757761AbZFCOqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761AbZFCOqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbZFCOq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:46:26 -0400
Received: from web50108.mail.re2.yahoo.com ([206.190.38.36]:31770 "HELO
	web50108.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753242AbZFCOqZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:46:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=EmHQ+p1WQ1Ir4NWOy7jVLMxpnzFnrHRI/Zi6QFWyE5y0oD0QG0Igvwlm++NpCDvOQGYuMSwd8vyXqffVAesUTcJxO55i3xaiof+j8LlTadRZcYxUtg9eA8xgDDpZP7DEVEytJSvTM0sjoIHgwrJihRib3m4Aen59kJpRvmMmsyo=;
Message-ID: <255444.45685.qm@web50108.mail.re2.yahoo.com>
X-YMail-OSG: lNwaqWAVM1lP5zCXE_3959Tnc6OWUuiM4672LXXQVCO8LeA1KjNn6CVxeADyYJ0bJy02z7cWklSS7aMClaK3jEKzYe1DUDVt8n9Z8_h1T6YUZ3QEUEdjjuktKmUeFVO7PyfNIC8_wlKa3AE..iS7ioBt3ZKbzecAtlQ57d8RoXPI6ztcPavnF5FVfr.YbZATBDgPyqN32qnZJ5VIKxBp5kVyDeAPX33hLGu7kUDppiVcVNaqqtyFShidQS.v3ngOyV1rtn05c1kRHtZgZf8CMRoZZvRiOHj1z69bFndzwozD2zKmsYIDrpydkCGHlVVNORBdU.fTC0zYWIim6xRpxkL1m2tFnG5ss0DcUIyoMBSUisA-
X-Mailer: YahooMailClassic/5.4.12 YahooMailWebService/0.7.289.10
Date: Wed, 3 Jun 2009 07:46:27 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] Fix the meaning of EDAC abbreviation
To: Jiri Kosina <trivial@kernel.org>, leemgs1@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>, dougthompson@xmission.com,
       Andrew Morton <akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Tue, 6/2/09, GeunSik Lim <leemgs1@gmail.com> wrote:

> From: GeunSik Lim <leemgs1@gmail.com>
> Subject: [PATCH] Fix the meaning of EDAC abbreviation
> To: "Jiri Kosina" <trivial@kernel.org>
> Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, dougthompson@xmission.com
> Date: Tuesday, June 2, 2009, 6:04 PM
> 
> 
> Dear Jiri Kosina,
> 
> This is trivial patch about meaning of EDAC in the
> driver/edac/Kconfig file.
>  * Screenshot after patch :
>    http://blogfiles16.naver.net/data42/2009/6/3/31/edac-before-after-invain.png
> 
> 
> Thanks, 
> 
> 
> Subject: [PATCH] Fix the meaning of EDAC abbreviation
> 
> Fix the meaning of EDAC(Error Detection And Correction)
> correctly.
>  - http://bluesmoke.sourceforge.net
> 
>         Signed-off-by: GeunSik Lim
> <geunsik.lim@samsung.com>
> ---
>  drivers/edac/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 956982f..2a81915 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -5,7 +5,7 @@
>  #
>  
>  menuconfig EDAC
> -    bool "EDAC - error detection and
> reporting"
> +    bool "EDAC - Error Detection And
> Correction"
>      depends on HAS_IOMEM
>      depends on X86 || PPC
>      help
> -- 
> 1.6.3.1


Good catch. All these years and I didn't see it. Always need more eyes


Acked-by: Doug Thompson <dougthompson@xmission.com>


