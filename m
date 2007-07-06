Return-Path: <linux-kernel-owner+w=401wt.eu-S1762687AbXGFH3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762687AbXGFH3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760133AbXGFH3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:29:31 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:64964 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbXGFH3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:29:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XeEa/u4A0bRiCBer+0l8q6c3HEK0xrstXEBPi8p7ZrFr3s1YpeuwtEonfLtcCUWlELlk2S9C6MK9BtrrkjdcJcY2E9l+60zmYOpOqB+ErUMGBTDMW1aTXDLssfT5oUloox2EWemAVH78byvxxZy87sVD+ghQJRyged6Ly+Fqc7U=
Message-ID: <a781481a0707060029r3ebf237bl84e27247f0943820@mail.gmail.com>
Date: Fri, 6 Jul 2007 12:59:28 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Guillaume LECERF" <glecerf@gmail.com>
Subject: Re: [PATCH] Libertas: Fix regression in cmd.c introduced in commit 18c96c3497aa871608d57ca5e08de3558159a6c9
Cc: linux-kernel@vger.kernel.org, "Dan Williams" <dcbw@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <b8e9195f0707051609v36182409mc07f030cca790a7a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b8e9195f0707051609v36182409mc07f030cca790a7a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guillaume,

[ Added relevant folks to Cc: ]

On 7/6/07, Guillaume LECERF <glecerf@gmail.com> wrote:
> [...]
>
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -241,7 +241,7 @@
>                 if (*enable)
>                         penableRSN->enable = cpu_to_le16(cmd_enable_rsn);
>                 else
> -                       penableRSN->enable = cpu_to_le16(cmd_enable_rsn);
> +                       penableRSN->enable = cpu_to_le16(cmd_disable_rsn);
>         }
>
>         lbs_deb_leave(LBS_DEB_CMD);
>

Thanks for the patch (looks reasonable to me), but:

1. No point sending a patch without a "Signed-off-by:" line.
2. Changelog (a few lines of explanation before signed-off-by) must
specify what was wrong, and why the patch is correct.
3. Always Cc: relevant maintainers or at least _somebody_ who
_will_ pick it up.
4. Gmail has done horrible things to the patch as usual, use some
other mailer or script.

And in general, please read: Documentation/SubmittingPatches
and http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt

Satyam
