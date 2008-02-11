Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbYBKRf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbYBKRf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759241AbYBKRfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:35:47 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:29625 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbYBKRfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:35:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PAUa8Qbby9csnq2CpbfR4Eu4ajSi6fQiGs6Yi81a4yB0nLxYwao/pR7x98+u5zO84GhtLV+Y3hf+VPsG474IyvZ4NLo9K0dWgt1NxE2nIG4asUoQl9Knhk4sK4jQixUFEXzQIicSCJDYFcSkJH6esmjB30OnwgkscAiO+0p8yvQ=
Message-ID: <82e4877d0802110935v11e4bdf8l783a9834ca0a950d@mail.gmail.com>
Date: Mon, 11 Feb 2008 12:35:39 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH] dmi: Prevent linked list corruption (resent)
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080211182440.071c47d9@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080211182235.14a5a641@hyperion.delvare>
	 <20080211182440.071c47d9@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 11, 2008 12:24 PM, Jean Delvare <khali@linux-fr.org> wrote:
> [Once more without forgetting the last "quilt refresh", sorry.]
>
> Adding the same item to a given linked list more than once is guaranteed
> to break and corrupt the list. This is however what we do in dmi_scan
> since commit 79da4721117fcf188b4b007b775738a530f574da.
>
> Given that there is absolutely no interest in saving empty OEM
> strings anyway, I propose the simple and efficient fix below: we
> discard the empty OEM strings altogether.
>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Parag Warudkar <parag.warudkar@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>

I suppose the list would be corrupted only if there are deletions from
the list? (Which there aren't.)

Anyway not adding the empty strings is way better and I don't see now
how they could've been useful.
(I added them out of the doubt of breaking something.)

Acked-By: Parag Warudkar <parag.warudkar@gmail.com>

Thanks

Parag
