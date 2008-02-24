Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbYBXEa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbYBXEa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 23:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbYBXEaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 23:30:16 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34002 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYBXEaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 23:30:14 -0500
Message-ID: <47C0E2FC.6040809@davidnewall.com>
Date: Sun, 24 Feb 2008 13:52:36 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Ray Lee <ray-lk@madrabbit.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@neteffect.com>,
       Faisal Latif <flatif@neteffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>  <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>  <20080221154951.GA28328@cs181133002.pp.htv.fi>  <adahcg2awag.fsf@cisco.com>  <20080221210124.GD28328@cs181133002.pp.htv.fi>  <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>  <m3tzk1q3rt.fsf@maximus.localdomain>  <47BE2985.6020305@davidnewall.com>  <20080222020615.GE27894@ZenIV.linux.org.uk>  <alpine.LFD.1.00.0802211858140.19896@woody.linux-foundation.org> <2c0942db0802212237t41da54b4h2aa2b052b7633f53@mail.gmail.com> <Pine.LNX.4.64.0802231628590.21077@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0802231628590.21077@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> static void blah(void)
> {
> 	if (foo) {
> 		bar;
> 		bar2;
> 		return;
> 	}
> 	if (this) {
> 		that;
> 		that2;
> 		return;
> 	}
> 	/* yay, got rid of two levels of indent! */
> 	good day;
> 	good day2;
> }

I like this style.  It's more readable than the alternative that you
showed.  If you hate returns mid-procedure, as some purists do, the
following is also good:

static void blah(void)
{
	if (foo) {
		bar;
		bar2;
	} else if (this) {
		that;
		that2;
	} else {
		good day;
		good day2;
	}
}

