Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab0BVOJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 09:09:25 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:54446 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab0BVOJX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 09:09:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eoBm/hvYt+L7O5xp0TNrtcD5ddcql7ytMcQCa65gJ+MLPpbd3velQaBsYdI38BMRBq
         ZpD9aHrwli0wukSnqpgqzQ/BLLm5ojmDxeqD5mCA5RGHMGQkWqRpSAoukniqE3hsdcap
         Z3Pzbda1XXL1VijQbVDXnJLDk17Xw3I1TrDrA=
MIME-Version: 1.0
In-Reply-To: <4B7FC140.60501@tuffmail.co.uk>
References: <4B7FC140.60501@tuffmail.co.uk>
Date: Mon, 22 Feb 2010 15:09:21 +0100
Message-ID: <71cd59b01002220609i5c471b62x1d1d4dcecd53a93@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: disable wireless hotplug for 1005PE
From: Corentin Chary <corentin.chary@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Ansgar Burchardt <ansgar@43-1.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 12:02 PM, Alan Jenkins
<alan-jenkins@tuffmail.co.uk> wrote:
> The wireless hotplug code is not needed on this model, and it disables
> the wired ethernet card.  (Like on the 1005HA and 1201N).
>
> References:
> <http://lists.alioth.debian.org/pipermail/debian-eeepc-devel/2010-February/003281.html>
>
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Reported-by: Ansgar Burchardt <ansgar@43-1.org>
> CC: stable@kernel.org
> ---
> drivers/platform/x86/eeepc-laptop.c |    3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/platform/x86/eeepc-laptop.c
> b/drivers/platform/x86/eeepc-laptop.c
> index e2be6bb..6a47bb7 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -1277,7 +1277,8 @@ static void eeepc_dmi_check(struct eeepc_laptop
> *eeepc)
>         * hotplug code. In fact, current hotplug code seems to unplug
> another
>         * device...
>         */
> -       if (strcmp(model, "1005HA") == 0 || strcmp(model, "1201N") == 0) {
> +       if (strcmp(model, "1005HA") == 0 || strcmp(model, "1201N") == 0 ||
> +           strcmp(model, "1005PE") == 0) {
>                eeepc->hotplug_disabled = true;
>                pr_info("wlan hotplug disabled\n");
>        }
> --
> 1.6.3.3
>

Ack,

Len, is it still possible merge this patch in the next rc ?
Thanks,


-- 
Corentin Chary
http://xf.iksaif.net
