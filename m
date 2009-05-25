Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbZEYW1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbZEYW1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbZEYW1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:27:40 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:55577 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753804AbZEYW1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:27:39 -0400
From: Frans Pop <elendil@planet.nl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 1/3] ide: add "ignore_hpa" module parameter
Date: Tue, 26 May 2009 00:27:38 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200905252344.11826.bzolnier@gmail.com>
In-reply-To: <200905252344.11826.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260027.39330.elendil@planet.nl>
X-OriginalArrivalTime: 25 May 2009 22:27:39.0971 (UTC) FILETIME=[036FA930:01C9DD88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
[...]
> +       ide_core.ignore_hpa=
> +                       [HW] (E)IDE subsystem
> +                       Ignore HPA limit

Add a short explanation of what HPA is maybe (or at least expand the 
acronym)?

It's also not obvious (at least not to a dumb user like me) that "ignore 
HPA limit" is equivalent to "preserving the Host Protected Area" as the 
commit commit says.
After reading the wiki page on HPA it looks like the actual meaning is to
"make the HPA visible to the OS"?

> +                       Format: { "0" | "1" }
> +                       0 -- keep BIOS limits
> +                       1 -- ignore limits, using full disk (default)

Hmm. This looks weird. Is "BIOS limits" a synonym for "HPA limit"?
Same goes for the MODULE_PARM_DESC.

Cheers,
FJP
