Return-Path: <linux-kernel-owner+w=401wt.eu-S1763883AbXFCC5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763883AbXFCC5v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 22:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763160AbXFCC5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 22:57:43 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:22208 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763065AbXFCC5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 22:57:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=geSZB28WFv/9UIg/qm1YsKXdHiJGMPeaV9vs++84xmabP4yMx84idSqvh3XOTKwk4P2eYYYtenQZWNZe137rmbh8oO6jC958LkHDT2lRirzRfQfENayT9HLTFjS2LhwuImsaY/juD983Ik5JyZd9azJm26+ylLWAWZS4RpAtfsk=
Message-ID: <7b69d1470706021957t4d6a1b43k33c0766b27975f31@mail.gmail.com>
Date: Sat, 2 Jun 2007 19:57:41 -0700
From: "Scott Preece" <sepreece@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch 1/1] document Acked-by:
Cc: "Adrian Bunk" <bunk@stusta.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20070602104700.53b6b811.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
	 <20070602141144.GC5500@stusta.de>
	 <20070602104700.53b6b811.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> ...
> +The Signed-off-by: tag implies that the signer was involved in the development
---

Change "implies" to "indicates" - it's an explicit statement, not an
implication.

---
> +of the patch, or that he/she was in the patch's delivery path.
> +
> +If a person was not directly involved in the preparation or handling of a
> +patch but wishes to signify and record their approval of it then they can
> +arrange to have an Acked-by: line added to the patch's changelog.
> +
> +Acked-by: is often used by the maintainer of the affected code when that
> +maintainer neither contributed to nor forwarded the patch themselves.
---

This using plural pronouns for indefinite gender leaves one in vague
territory, but I think "themself" would be better than "themselves,
since "maintainer" is singular.

---
> +
> +Acked-by: is not as formal as Signed-off-by:.  It is a record that the acker
> +has at least reviewed the patch and has indicated acceptance.  Hence patch
> +mergers will sometimes manually covert an acker's "yep, looks good to me" into
---

"covert" -> "convert"

---
> +an Acked-by:.
> +
> +Acked-by: does not necessarily indicate acknowledgement of the entire patch.
> +For example, if a patch affects multiple subsystems and has an Acked-by: from
> +one subsystem maintainer then this usually indicates acknowledgement of just
> +the part which affects that maintainer's code.  Judgement should be used here.
> +When in doubt people should refer to the original discussion in the mailing
> +list archives.
> +
> +
> +14) The canonical patch format
>
>  The canonical patch subject line is:
