Return-Path: <linux-kernel-owner+w=401wt.eu-S1758252AbZIPJTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbZIPJTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758161AbZIPJTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:19:16 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41661 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZIPJTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:19:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FNg5fJeNqJSPQaYfcrkWWZm1Yu+DSXlXMNEHYZDPU+30/TIxv6rCnE5m26IezGydKJ
         01/1I5y2mjH0Q4gLGnWaucZHcRiyhEn0KpL7fCaGilxMCnLg8YyGefEclwWBzgbc6kn9
         MZsMVzrelEoMXFgbezz4Uwk4Fm1xlZzY6z5c0=
Date: Wed, 16 Sep 2009 11:19:11 +0200
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Cc: "Graham, David" <david.graham@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [E1000-devel] [BUG 2.6.30+] e100 sometimes causes oops during
	resume
Message-ID: <20090916091911.GA1496@bizet.domek.prywatny>
References: <20090915120538.GA26806@bizet.domek.prywatny> <13830B75AD5A2F42848F92269B11996F5BF592C3@orsmsx509.amr.corp.intel.com> <20090916014448.GA1070@bizet.domek.prywatny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916014448.GA1070@bizet.domek.prywatny>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 03:44:48AM +0200, Karol Lewandowski wrote:
> On Tue, Sep 15, 2009 at 03:54:20PM -0700, Graham, David wrote:
> 
> > A v2.6.30..v2.6.31 diff shows that this is probably exposed by
> > Rafael Wysocki's commit 6905b1f1, which now allows systems with e100
> > to sleep. If I understand correctly, it looks like these systems
> > simply couldn't sleep before. Is that right Rafael?.
> 
> Probably true, but that wasn't the case for my (I guess
> ACPI-controlled) system.
> 
> 
> > I don't think its likely that the commit is a direct cause of the
> > problem, but that the suspend/resume cycle now allows us to see
> > another issue.
> 
> From my (very limited) understanding commit message is at least in
> conflict with patch body.

No, it isn't, I must just go to bed earlier than 4AM. :/

Sorry for noise.
