Return-Path: <linux-kernel-owner+w=401wt.eu-S933899AbYEBPBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899AbYEBPBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbYEBPBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:01:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:29493 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576AbYEBPBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:01:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=pOgAF+3Pw12U31Y110E/puLJfkmSWtBfPj3xu+5q279fi53sMfH4l1qE4rsIDUltzhdNf6zVlbKjNhRdwZ9F7/TI+/mJ/r7UrugSiA/xQLH9mjdQ8SzTPaMfwWK8oxjpdjfTFDKu2B4jQOyHNfhiDEyRIjgMD3tjhtdMWNcjv+M=
Message-ID: <481B2CB8.2000307@gmail.com>
Date: Fri, 02 May 2008 17:01:12 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Andrew Morton <akpm@linux-foundation.org>, megaraidlinux@lsi.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH #repost] SCSI: megaraid, fix suspend/resume sections
References: <1209657362-20300-1-git-send-email-jirislaby@gmail.com>	 <20080501142305.77433e50.akpm@linux-foundation.org>	 <481A3781.8080100@gmail.com>	 <1209679559.14864.33.camel@localhost.localdomain>	 <20080501153048.2a8d356f.akpm@linux-foundation.org> <1209740170.3121.24.camel@localhost.localdomain>
In-Reply-To: <1209740170.3121.24.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley napsal(a):
>>> could we not at least make the machinery do something vaguely
>>> useful and expand it to confine the pm routines to sections which can be
>>> discarded if CONFIG_PM is n?
>> a) it would need to be discarded at link-time, ideally.
> 
> Yes, the same way the exit sections are: as linker discards.  We also
> have the mechanics for runtime discards which is useful for modules

No it doesn't, exits are discarded at runtime only. At least on x86.
