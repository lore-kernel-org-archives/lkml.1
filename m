Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbZIPJhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbZIPJhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758303AbZIPJhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:37:32 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:43980 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159AbZIPJhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:37:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZNUV+2SptR/3cfuqp2Gp7sJy14fZ3pqJJRPFV9mw/y4T5tmnUo2IVbbADgDj6wdifw
         8/6pbaMo7u0x+eQq1QseSz1J2bxSiaAVpKOYPfSxv1QltjGnhg22vaH+Rpq+UADlnv57
         qNusGLXjcXJ7ONbARW2yvP8OTmuWuUGcSc54k=
Date: Wed, 16 Sep 2009 13:37:31 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sheng Yang <sheng@linux.intel.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Jun Nakajima <jun.nakajima@intel.com>,
       Eddie Dong <eddie.dong@intel.com>, linux-kernel@vger.kernel.org,
       xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [RFC][PATCH 08/10] x86: Don't ack_APIC_irq() if lapic is
	disabled in GENERIC_INTERRUPT_VECTOR handler
Message-ID: <20090916093731.GG5094@lenovo>
References: <1253090551-7969-1-git-send-email-sheng@linux.intel.com> <1253090551-7969-9-git-send-email-sheng@linux.intel.com> <20090916085835.GE5094@lenovo> <20090916090306.GF5094@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916090306.GF5094@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Wed, Sep 16, 2009 at 01:03:06PM +0400]
| [Cyrill Gorcunov - Wed, Sep 16, 2009 at 12:58:35PM +0400]
| ...
| | 
| | Hi Sheng,
| | 
| | is there was some problem with it? I'm asking you
| | because if disable_apic=1 then any apic write/read
| | operations become NOPs. So I don't see how it may
| | hurt. But I could be missing something.
| |  
| | 	-- Cyrill
| 
| Ah, I see -- it's due to your other patch...
| Hmm this makes all "disable apic" idea less
| general. And safety of ack_APIC_irq is now
| under suspicious.
| 
| 	-- Cyrill

And how msi_compose_msg would work then?

Don't get me wrong please, I'm just trying to understand.
Perhaps Xen specifics will handle it (I didn't read Xen
internals) by substituting all this with own handler.

Since comments are requested I thought I may ask? :)

	-- Cyrill
