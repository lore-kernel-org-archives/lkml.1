Return-Path: <linux-kernel-owner+w=401wt.eu-S1759460AbZB0BDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460AbZB0BDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 20:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZB0BDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 20:03:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:51277 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZB0BDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 20:03:34 -0500
MIME-Version: 1.0
In-Reply-To: <20090222000228.17557.1852.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
	 <20090222000228.17557.1852.stgit@vmbox.hanneseder.net>
Date: Fri, 27 Feb 2009 02:03:31 +0100
Message-ID: <154e089b0902261703r76f23065vaf1e683a4f8f4bb2@mail.gmail.com>
Subject: Re: [PATCH 07/16] panasonic-laptop: fix sparse warning: Using plain 
	integer as NULL pointer
From: Hannes Eder <hannes@hanneseder.net>
To: trivial@kernel.org, Len Brown <len.brown@intel.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added To]

On Sun, Feb 22, 2009 at 1:02 AM, Hannes Eder <hannes@hanneseder.net> wrote:
> Fix this sparse warning:
>  drivers/platform/x86/panasonic-laptop.c:273:70: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  drivers/platform/x86/panasonic-laptop.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
> index c47a44d..e178cde 100644
> --- a/drivers/platform/x86/panasonic-laptop.c
> +++ b/drivers/platform/x86/panasonic-laptop.c
> @@ -270,7 +270,7 @@ static int acpi_pcc_retrieve_biosdata(struct pcc_acpi *pcc, u32 *sinf)
>        union acpi_object *hkey = NULL;
>        int i;
>
> -       status = acpi_evaluate_object(pcc->handle, METHOD_HKEY_SINF, 0,
> +       status = acpi_evaluate_object(pcc->handle, METHOD_HKEY_SINF, NULL,
>                                      &buffer);
>        if (ACPI_FAILURE(status)) {
>                ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
>
>
