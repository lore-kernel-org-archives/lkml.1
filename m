Return-Path: <linux-kernel-owner+w=401wt.eu-S937070AbXHMUbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937070AbXHMUbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032919AbXHMU3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:29:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:60945 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032926AbXHMU3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:29:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sHF9dRZHLQG1m7u5D0pfH3hxjCym9k+mOHSzRRCAEOKuDooSYHs7FC++VPvWTVulACzzr5egZhM13rjTp6FaAgbtTuoJrL1DpE2DOFVjtvZzZBz0YcTw0fdCK/A5kNeZyPZSquzj1fDAU1bbDwCxjbHkmgL1dhieC0xyRB/MQkU=
Message-ID: <6bffcb0e0708131329l492ad840h12109b8b50ff1954@mail.gmail.com>
Date: Mon, 13 Aug 2007 22:29:47 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: 2.6.23-rc3 regression and bisection query
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Len Brown" <len.brown@intel.com>,
       "Henrique de Moraes Holshuh" <hmh@hmh.eng.br>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708131905280.13982@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0708131905280.13982@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/07, Hugh Dickins <hugh@veritas.com> wrote:
> Two issues in this mail, sorry if I'd have done better to separate them.
>
> One: Thinkpad T43p suspend-to-RAM regression.
>
> Verily, what Len giveth with one hand, he taketh away with the other.
> Henrique's fix to CONFIG_THINKPAD_ACPI_INPUT_ENABLED default is now in,
> thanks, so Fn-F4 ought now to Suspend to RAM on the Thinkpad T43p.
> Except that it doesn't.
>
> Git bisection (with manual fixups to i386 mmiocfg horror, thanks
> for drawing attention to that in your changelog) accuses Alexey's
> ACPI: EC: If ECDT is not found, look up EC in DSDT
> cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b
> and if I revert that along with Len's subsequent
> ACPI: EC: fix build warning
> 52fe4bdf40bc07498c5f7935551774e8f8458190
> then I have Fn-F4 suspending to RAM again.
>
> It's not obvious to me how Alexey's patch might be interfering with
> Thinkpad STR, but of course I can try any patches suggested.  Hmm,
> does "echo mem >/sys/power/state" work instead?  Apparently, except
> then we cannot resume after, the screen remains blank - though I'm
> not in the habit of using /sys/power/state, maybe that's unrelated.
>
> Two: oddity noticed in doing that git bisection.
>
> I'd told it v2.6.23-rc2 good and v2.6.23-rc3 bad.  Happily rebooting
> various versions of 2.6.23-rc2-git (CONFIG_LOCALVERSION="-git").
> Caught by surprise when I realized that actually the last few kernels
> it had built were actually 2.6.23-rc1-git.  Bisection log below from
> a correct second attempt: git --version 1.5.2.4.
>
> Is that right?

I think that this is a normal thing.

Thanks for the report.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
