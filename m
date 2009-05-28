Return-Path: <linux-kernel-owner+w=401wt.eu-S1760610AbZE1FQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610AbZE1FQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 01:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbZE1FQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 01:16:39 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:42138 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZE1FQi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 01:16:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ro0l2XPirzAclEVjpRhpC8scDBTS2MryW7QIWlkalV4J1Qkzegbsk2mJQEN4J04RHo
         q/b8EUv14NCX2FVe93wSsOJVUNd4Z7iSyyhgNNNJUaMnts3Xn7YFJqOlx2sE1klUvUSj
         ppf1krhX0WUCiCkzZfCCjjkI1m/Y0knse0HHw=
MIME-Version: 1.0
In-Reply-To: <1243487718-5423-3-git-send-email-philipp.zabel@gmail.com>
References: <878wkibmv9.fsf@free.fr>
	 <1243487718-5423-3-git-send-email-philipp.zabel@gmail.com>
Date: Thu, 28 May 2009 07:16:39 +0200
Message-ID: <74d0deb30905272216g709485f8wc2ddeaab6cd9298d@mail.gmail.com>
Subject: Re: [PATCH 4/5] pxa/mioa701: add V3 gain configuration for Maxim 1586 
	voltage regulator
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That should have been "[PATCH 2/3] pxa/mioa701: ..."

On Thu, May 28, 2009 at 7:15 AM, Philipp Zabel <philipp.zabel@gmail.com> wrote:
> Maxim 1586 V3 gain can be configured by external resistors
> (R24, R25) connected to the FB3 pin. To avoid accidental
> overvoltage, it now requires this gain to be configured
> explicitly.
>
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  arch/arm/mach-pxa/mioa701.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
> index 54c91db..d805218 100644
> --- a/arch/arm/mach-pxa/mioa701.c
> +++ b/arch/arm/mach-pxa/mioa701.c
> @@ -746,6 +746,7 @@ static struct max1586_subdev_data max1586_subdevs[] = {
>  static struct max1586_platform_data max1586_info = {
>        .subdevs = max1586_subdevs,
>        .num_subdevs = ARRAY_SIZE(max1586_subdevs),
> +       .v3_gain = MAX1586_GAIN_NO_R24, /* 700..1475 mV */
>  };
>
>  /*
> --
> 1.6.3.1
>
>
