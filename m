Return-Path: <linux-kernel-owner+w=401wt.eu-S1762793AbXJYUuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762793AbXJYUuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbXJYUuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:50:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:58536 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbXJYUun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:50:43 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Subject: Re: [2.6 patch] fujitsu-laptop.c: make 2 functions static
Date: Thu, 25 Oct 2007 16:50:25 -0400
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
References: <200710250507.l9P57Pwh003203@turbo.physics.adelaide.edu.au>
In-Reply-To: <200710250507.l9P57Pwh003203@turbo.physics.adelaide.edu.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251650.25768.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

thanks,
-Len

On Thursday 25 October 2007 01:07, Jonathan Woithe wrote:
> > acpi_fujitsu_{add,remove}() can become static.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Looks fine.  Ack.
> 
> Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
> 
> jonathan
> 
> ---
>  drivers/misc/fujitsu-laptop.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 175c8b648a54b625037916a8f6e3851574141532 
> diff --git a/drivers/misc/fujitsu-laptop.c b/drivers/misc/fujitsu-laptop.c
> index d366a6c..d686ba7 100644
> --- a/drivers/misc/fujitsu-laptop.c
> +++ b/drivers/misc/fujitsu-laptop.c
> @@ -198,7 +198,7 @@ static struct platform_driver fujitsupf_driver = {
>  
>  /* ACPI device */
>  
> -int acpi_fujitsu_add(struct acpi_device *device)
> +static int acpi_fujitsu_add(struct acpi_device *device)
>  {
>  	int result = 0;
>  	int state = 0;
> @@ -229,7 +229,7 @@ int acpi_fujitsu_add(struct acpi_device *device)
>  	return result;
>  }
>  
> -int acpi_fujitsu_remove(struct acpi_device *device, int type)
> +static int acpi_fujitsu_remove(struct acpi_device *device, int type)
>  {
>  	ACPI_FUNCTION_TRACE("acpi_fujitsu_remove");
>  
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
