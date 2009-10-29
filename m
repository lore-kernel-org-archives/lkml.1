Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbZJ2WuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbZJ2WuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 18:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbZJ2WuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 18:50:23 -0400
Received: from smtp111.rog.mail.re2.yahoo.com ([206.190.37.1]:32236 "HELO
	smtp111.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756779AbZJ2WuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:50:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=GmBVj14i3aIREnGIHE2x+8OFVPRp1O2m3azya5ua/YV03+hsEdKA0ltz9z1opsd0U4jZDHLXWNE2eWb50Sc+jO5R8y9MfbpWeMr31wEyK9MABqb2O9PLY76r12Yyf/hRlAt8aRAzJ9zxZFY4U0rd/inxnnoEn9NTdt79cK1xFcg=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: 3PPdpTgVM1mgxFwp4lMH8HF0awVs4C7hAUmQVUB9xgXucmG5hG7IU2EPPiNdWCiEJg--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: Andrew Lutomirski <luto@mit.edu>
Subject: Re: [Bug #14472] EXT4 corruption
Date: Thu, 29 Oct 2009 18:43:40 -0400
User-Agent: KMail/1.12.90 (Linux/2.6.32-rc5-custom; KDE/4.3.73; x86_64; svn-1042058; 2009-10-28)
Cc: Theodore Tso <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <20091029222335.GJ18464@mit.edu> <cb0375e10910291534j485b9e55vc42c3ce94a30252c@mail.gmail.com>
In-Reply-To: <cb0375e10910291534j485b9e55vc42c3ce94a30252c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910291843.41253.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On October 29, 2009 06:34:45 pm Andrew Lutomirski wrote:
> On Thu, Oct 29, 2009 at 6:23 PM, Theodore Tso <tytso@mit.edu> wrote:
> > On Thu, Oct 29, 2009 at 03:57:32PM -0400, Andrew Lutomirski wrote:
> >> This but is *not* fixed.  I just triggered it a few minutes ago by
> >> abusing i915 and drm, which caused a panic.  This is slightly newer
> >> than 2.6.32-rc5, with a couple of i915 bugfixes thrown in.
> >
> > Andrew, can you test to see if this patch helps?
> 
> I'm building a kernel with that patch now, and I'll keep running it
> for awhile.  I only seem to trigger this bug once a month or so, so
> I'll let you know if I see any more corruption.
> 
> Thanks,
> Andy
> 

You should be able to trigger this using the same method I did. To mistakenly 
cause modprobe to spawn unlimited processes ending up in a swap storm.

Thanks, 
Shawn.
