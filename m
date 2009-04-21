Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbZDUFwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbZDUFwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 01:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZDUFvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 01:51:50 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:14981 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbZDUFvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 01:51:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pK+Y6qVyh0MhRVeHwptb0U7PaZsODIXH3WOXUB6ZbVZGmqIlie1seX1i50e9kGRAj7
         OucPXr5gU0/T4Ct7wpT77vVtI5FMTw+t6YyzAb97sx7ARy7DR7ycvjPFNfOccxPIZODP
         cFURalNsmUZVWNvVXbwzzHoO/K7Yud/pkCwgE=
MIME-Version: 1.0
In-Reply-To: <49ecf25e2378234eed@agluck-desktop.sc.intel.com>
References: <49ecf25e2378234eed@agluck-desktop.sc.intel.com>
Date: Tue, 21 Apr 2009 08:51:47 +0300
X-Google-Sender-Auth: 9339afaf00237488
Message-ID: <84144f020904202251n616f188k80c6ce7d974d8b00@mail.gmail.com>
Subject: Re: linux-next ia64 build problems in slqb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       randy.dunlap_ocs10g@oracle.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Tue, Apr 21, 2009 at 1:08 AM, Luck, Tony <tony.luck@intel.com> wrote:
> The ia64 "allnoconfig" build ends up with the (possibly dubious) combination
> of .config options:
>
>        CONFIG_SMP=n
>        CONFIG_NUMA=y

Yeah, I don't think the combination makes much sense and x86 doesn't
allow it. Can we fix that in ia64 Kconfig? That said, this seems to
come up with every architecture except x86, so if someone is kind
enough to send me a tested fix for slqb, I'll just go ahead and apply
it.

                                   Pekka
