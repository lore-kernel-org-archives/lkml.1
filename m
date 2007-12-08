Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbXLHUsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbXLHUsw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbXLHUsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:48:43 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43345 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbXLHUsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:48:42 -0500
Message-ID: <475B02EC.4080200@garzik.org>
Date: Sat, 08 Dec 2007 15:47:40 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>,
       Mike McGrath <mmcgrath@redhat.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org,
       hmh@debian.org
Subject: Re: entropy gathering (was Re: Why does reading from /dev/urandom
 deplete entropy so much?)
References: <4756B50B.3060100@redhat.com> <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion> <20071208173204.GI17037@thunk.org> <475AD585.7020908@redhat.com> <20071208174908.GJ17037@thunk.org> <20071208181525.GL19691@waste.org> <475AF241.5000809@garzik.org> <20071208195342.GO19691@waste.org> <475AF8D0.1090407@garzik.org> <20071208203121.GP17037@thunk.org>
In-Reply-To: <20071208203121.GP17037@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> I think the userspace config problems were mainly due to the fact that
> there wasn't a single official userspace utility package for the
> random number package.  Comments in drivers/char/random.c for how to
> set up /etc/init.d/random is Just Not Enough.

Absolutely.


> If we had a single, official random number generator package that
> contained the configuration, init.d script, as well as the daemon that
> can do all sorts of different things that you really, Really, REALLY
> want to do in userspace, including:
> 
>   * FIPS testing (as Jeff suggested --- making sure what you think is 
>     randomness isn't 60Hz hum is a Really Good Idea :-)
>   * access to TPM (if available --- I have a vague memory that you may
>     need access to the TPM key to access any of its functions, and the
>     the TPM key is stored in the filesystem)

+1 agreed

(not volunteering, but I will cheer on the hearty soul who undertakes 
this endeavor...)

