Return-Path: <linux-kernel-owner+w=401wt.eu-S1759791AbZE0KOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791AbZE0KOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 06:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbZE0KOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 06:14:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:20229 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297AbZE0KOa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 06:14:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vjUU324m8/1TiroxE1zdIYXZVTzhP1mUxz569f6464INLd+p8hJ6B2wzXQu0sIkc1u
         e48ee6lOGDerLrkv9r4D6ycJN0joERSulN9hFig/3Me7kIQQLu6Ushp47BZnubLZyk9K
         OaZzx5/Bz721zEic7nFtVoAt1NH2/ycQ4E/zE=
MIME-Version: 1.0
In-Reply-To: <4A1C5CF0.3090107@redhat.com>
References: <1242170724-13349-1-git-send-email-jeremy@goop.org>
	 <20090519123548.GA26439@elte.hu> <4A14447E.9060607@goop.org>
	 <20090525041057.GD9396@elte.hu>
	 <de76405a0905260546k56bc866bx1658ec13f65e3eec@mail.gmail.com>
	 <4A1C5CF0.3090107@redhat.com>
Date: Wed, 27 May 2009 11:14:30 +0100
X-Google-Sender-Auth: 910b3e3970cd6207
Message-ID: <de76405a0905270314x43ba3f77uae80676c4a83f0cd@mail.gmail.com>
Subject: Re: [Xen-devel] Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
From: George Dunlap <George.Dunlap@eu.citrix.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 10:19 PM, Gerd Hoffmann <kraxel@redhat.com> wrote:
> Well.  Xen *does* suffer from bad technical choices made years ago.  I'm
> pretty sure Xen would look radically different when being rewritten from
> scratch today.

That may be.  I don't know enough about the specific issues you raise
below to comment.  But Ingo wasn't bringing up those issues: he was
disagreeing with the whole idea of including dom0 Linux as a key
component of the Xen system.  If the Xen project were to start over
from scratch, we might make a lot of different decisions; but running
Linux as the hypervisor (as KVM does) or forking Linux (as Ingo seemed
to suggest) are not among them.

 -George
