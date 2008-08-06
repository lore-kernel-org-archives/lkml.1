Return-Path: <linux-kernel-owner+w=401wt.eu-S1762145AbYHFUO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145AbYHFUO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbYHFUOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:14:48 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:52767 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064AbYHFUOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:14:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eRngDxde6WfbTQLdwjYow3hzpzXfZkt/8bV3c9LF+Osyvfru4YNwJRp8DlEEG2PIRN
         fekV4aUkqjNe4cbttCmBeP3uXUJWFzjUxLLTKyF55AIHe2vQmz8R/EMZ3VOBVd4mXZSj
         KCiR87TSn1vkjzMuBbK1WUMduMPikAN4oDIO8=
Message-ID: <b647ffbd0808061314n3bbe3396ncf0844cceb2576ac@mail.gmail.com>
Date: Wed, 6 Aug 2008 22:14:45 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Peter Oruba" <peter.oruba@amd.com>
Subject: Re: [patch 0/5] x86-microcode: run ucode update via workqueue
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Max Krasnyansky" <maxk@qualcomm.com>,
       "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080806152117.198754464@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080806152117.198754464@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

>
> Rebased Dmitry's patch set to x86-microcode and incorporated changes into AMD microcode patch loader. No issues with
> cpu-hotplug anymore, tested on Intel as well as AMD.

btw., I still think we should consider running ucode-updates from the
low-level arch code. But as it's perhaps a material for .28, there
should be plenty of time. I also have in mind a few possible
generalizations/improvemets.
I'll base them on top of your recent patches.


>
> --Peter
>

-- 
Best regards,
Dmitry Adamushko
