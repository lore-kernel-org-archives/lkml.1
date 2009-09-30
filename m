Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbZI3XBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbZI3XBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZI3XBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:01:41 -0400
Received: from solo.fdn.fr ([80.67.169.19]:57540 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbZI3XBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:01:41 -0400
Date: Thu, 1 Oct 2009 01:01:38 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH,TRIVIAL] Fix csum_ipv6_magic asm memory clobber
Message-ID: <20090930230138.GZ6451@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Andi Kleen <andi@firstfloor.org>
References: <20090926192748.GX7681@const.famille.thibault.fr> <20090930154044.0c7ace16.akpm@linux-foundation.org> <4AC3DF7B.5060407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AC3DF7B.5060407@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin, le Wed 30 Sep 2009 15:45:15 -0700, a écrit :
> On 09/30/2009 03:40 PM, Andrew Morton wrote:
> > You describe it as "trivial" and also cc stable@kernel.org.  These things
> > are contradictory!
> > 
> > Maybe backporting it is a good idea from a sleep-soundly-at-night POV. 
> > I don't know..
> 
> /me suspects it was supposed to mean "trivially correct",

Yes.

> which isn't really what "trivial" means.

Ah.

> This is a potentially serious bug and should be treated as such.

Yes.  Actually it hit Hurd's pfinetv4 when we tried to compile it with
gcc-4.3 (bogus checksums).

Samuel
