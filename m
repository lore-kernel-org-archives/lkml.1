Return-Path: <linux-kernel-owner+w=401wt.eu-S966070AbZLHUsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966070AbZLHUsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbZLHUse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:48:34 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:29772 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbZLHUse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:48:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TPNPDWVaTUXFn0e4qS4wYUbcau65hUVmMFUvfiX6eXhS3lVaRN5rdYnNqkWyzx5UIU
         dvFXtjlILho9pfLgNGN3tDyfAdKFm08nNxoTswhhymGZszaIbe/8nQyntblq8SV+2jja
         pYgnUL+1HWnglyt5A6cUS92YcvG0uBy2cM3zQ=
Date: Tue, 8 Dec 2009 23:48:38 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, macro@linux-mips.org,
       yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86,apic: Use logical OR in noop-write operation
Message-ID: <20091208204838.GA26156@lenovo>
References: <20091208155316.561853924@openvz.org> <20091208155557.326359748@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208155557.326359748@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 06:53:18PM +0300, Cyrill Gorcunov wrote:
> For apic noop'ified we have to use logical OR statement,
> otherwise any write on systems shipped with 82489DX
> (where apic presence bit can't be retrieved via cpuid)
> will not trigger the warning which is not desired.
>
...

Ingo please dont apply this patch. Perhaps we may warn unconditionally
(as Peter marked) which would be more clear approach indeed. Need more
time to check all code flows.

Sorry for inconvenience.

	-- Cyrill
