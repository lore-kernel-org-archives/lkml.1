Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbYHALZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbYHALZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 07:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYHALZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 07:25:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:55575 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbYHALZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 07:25:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=X2yxXMYk91x0DNYSkiLP/irCvPztNGu2VJRFosb5UBGxYLFGX+PyG+N1PZ2FqBHwYv
         sNjfh0dikKBYl8dYO0kZlOIMVv6zU7WFefV+v/PX5kbvIH9bRvP3AcjDmfpXUJYxtPs5
         i5Cv7B9F5gdb3HPvy6opIkrbCQ/hVLme94vrw=
Message-ID: <b647ffbd0808010425r16db2957i3e7212903a698c19@mail.gmail.com>
Date: Fri, 1 Aug 2008 13:25:26 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Peter Oruba" <peter.oruba@amd.com>,
       "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>
Subject: Re: [patch 0/4] x86: AMD microcode patch loading v2 fixes
Cc: "Max Krasnyansky" <maxk@qualcomm.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48903431.9060707@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080729154103.007575982@amd.com>
	 <b647ffbd0807290918kaa0a05es3cebf7a6f15fb790@mail.gmail.com>
	 <488F581B.7060009@qualcomm.com> <48903431.9060707@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tigran, Peter,


may a firmware package contain a few 'microcode' updates for a specific cpu?

And if so, does each of them provide independent 'errata' fixes? [*]

(or they are just different versions of the same self-consistent/full
'microcode' update and we may need to apply each of them just e.g.
because we can't jump from stepping X.1 to X.3 without applying X.2 in
between?

if it's [1], then I wonder why only a single 'microcode' update (which
has been previously cached in 'uci->mc') is being applied for the case
of system-wide resume (apply_microcode_check_cpu()). Don't we need to
go through the full cpu_request_microcode() cycle to consider all
updates?


TIA,

-- 
Best regards,
Dmitry Adamushko
