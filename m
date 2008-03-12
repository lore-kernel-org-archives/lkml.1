Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbYCLWlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbYCLWlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYCLWkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:40:55 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:47168
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbYCLWky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:40:54 -0400
Message-ID: <47D869D1.4040107@microgate.com>
Date: Wed, 12 Mar 2008 17:40:01 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: rupesh.sugathan@gmail.com
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: + n_tty-loss-of-sync-following-a-buffer-overflow.patch added
 to -mm tree
References: <200803120455.m2C4t4Aw010881@imap1.linux-foundation.org>	 <20080312102729.58956d2c@the-village.bc.nu>	 <47D7F531.2070400@microgate.com>  <1205339539.8873.14.camel@estonia>	 <1205343590.4094.17.camel@x2.microgate.com>	 <47D844B5.2090001@microgate.com> <1205355283.8873.29.camel@estonia>
In-Reply-To: <1205355283.8873.29.camel@estonia>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rupesh Sugathan wrote:
> I have another suggestion to this subject. When the buffer oveflows in
> icaonon mode, it would be *best* if the application either gets a
> complete line or does not get it at all. On a buffer overflow, it would
> be good that the n_tty discard the whole line data in the buffer (part
> of which has overflown) and make more room in the buffer.
> 
> Does it make sense to any of you?

I don't know if there is a standard behavior under
these conditions so it is hard to argue it should
be handled a particular way other than leaving the
device in a consistent and recoverable state.

I doubt there would be support for making such changes.
Making that decision in the kernel and
having an application depend on that non-portable
behavior does not make sense.

Given that a n_tty receive overflow is not possible in
the current kernel (though data can still be lost elsewhere),
I doubt even my patch merits inclusion.

--
Paul

