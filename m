Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbYJ1Fu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbYJ1Fu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 01:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYJ1Fus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 01:50:48 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:37216 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYJ1Fus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 01:50:48 -0400
Date: Tue, 28 Oct 2008 01:50:45 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [patch/RESEND 2.6.28-rc2 1/2] ACPI:  fix ACPI_FADT_S4_RTC_WAKE
 comment
In-reply-to: <200810271357.23861.david-b@pacbell.net>
X-X-Sender: lenb@localhost.localdomain
To: David Brownell <david-b@pacbell.net>
Cc: linux-acpi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.2.00.0810280150300.24123@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200810271357.23861.david-b@pacbell.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forwarded to devel@lists.acpica.org

thanks,
-len

On Mon, 27 Oct 2008, David Brownell wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Make the comment for ACPI_FADT_S4_RTC_WAKE match the ACPI spec;
> that bit has nothing to do with status bits.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  include/acpi/actbl.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/include/acpi/actbl.h	2008-08-19 20:25:36.000000000 -0700
> +++ b/include/acpi/actbl.h	2008-08-19 20:26:14.000000000 -0700
> @@ -245,7 +245,7 @@ struct acpi_table_fadt {
>  #define ACPI_FADT_POWER_BUTTON      (1<<4)	/* 04: Power button is handled as a generic feature */
>  #define ACPI_FADT_SLEEP_BUTTON      (1<<5)	/* 05: Sleep button is handled as a generic feature, or  not present */
>  #define ACPI_FADT_FIXED_RTC         (1<<6)	/* 06: RTC wakeup stat not in fixed register space */
> -#define ACPI_FADT_S4_RTC_WAKE       (1<<7)	/* 07: RTC wakeup stat not possible from S4 */
> +#define ACPI_FADT_S4_RTC_WAKE       (1<<7)	/* 07: RTC wakeup possible from S4 */
>  #define ACPI_FADT_32BIT_TIMER       (1<<8)	/* 08: tmr_val is 32 bits 0=24-bits */
>  #define ACPI_FADT_DOCKING_SUPPORTED (1<<9)	/* 09: Docking supported */
>  #define ACPI_FADT_RESET_REGISTER    (1<<10)	/* 10: System reset via the FADT RESET_REG supported */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
