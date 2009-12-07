Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbZLGGcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbZLGGcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 01:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZLGGcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 01:32:36 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:39668 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbZLGGcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 01:32:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GJnwMHekAWtSOOnqFZynqSwjNYh4amWHVAJEmLS0TUplIMgNzdTtjw7vsVYlX4CaDb
         0TRoUS3D3T+Ua8714QaafkYpLeuHn/0Ohy5KTwwEEL09hl8lWCNEYmyVFJSy0aPbBqRI
         uNqmz7MKLtDSrBULKiFofcwzWU191VRFXXg6E=
Date: Sun, 6 Dec 2009 22:32:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Message-ID: <20091207063236.GF21451@core.coreip.homeip.net>
References: <alpine.LFD.2.00.0912051758190.3560@localhost.localdomain> <20091206113555.5a646713@infradead.org> <alpine.LFD.2.00.0912061144100.3560@localhost.localdomain> <20091206121803.70385c33@infradead.org> <7AB497C7-8495-4535-9E83-81307E008BF4@gmail.com> <20091206171856.394ce6d8@infradead.org> <20091207022706.GA20770@core.coreip.homeip.net> <20091206213112.568c602b@infradead.org> <20091207061548.GB21451@core.coreip.homeip.net> <20091206223112.77433d13@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091206223112.77433d13@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 06, 2009 at 10:31:12PM -0800, Arjan van de Ven wrote:
> On Sun, 6 Dec 2009 22:15:49 -0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > And the bad thing is that violates multiple layers in the kernel.
> > Atkbd driver does not have to be using i8042; neither does psmouse.
> > Althtough they do in 99% of the cases there are other controllers
> > providing the i8042-style ports. Just grep for SERIO_8042 in
> > drivers/input/serio.
> > 
> > I do not want to hard-code the i8042-psmouse-atkbd dependency.
> 
> it's not a specific dependency.
> 
> it's a "I know I'm critical, so everything before me needs to be done".
> 
> that doesn't encode an actual relationship, it encodes a potential
> relationship... with a worst case behavior of ... what we do right
> now ;_)

This is the case with every parent device, isn't it? It is important for
its children. And wasn't Rafael patchset trying to address exactkly
this?

-- 
Dmitry
