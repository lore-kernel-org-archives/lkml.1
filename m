Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910Ab0AGU4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab0AGU4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102Ab0AGU4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:56:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:26753 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab0AGU4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:56:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,237,1262592000"; 
   d="scan'208";a="585276995"
Date: Thu, 7 Jan 2010 12:55:58 -0800
From: mark gross <mgross@linux.intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: 640E9920 <640e9920@gmail.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [RFC] PM_QOS api update to use handles 1/5
Message-ID: <20100107205558.GB5703@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20091130010953.GA4732@mgross-laptop>
 <20100104083127.GA1450@ucw.cz>
 <20100106191132.GD21316@linux.intel.com>
 <20100106191831.GA3045@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106191831.GA3045@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 08:18:31PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > Umm.. passing binary numbers like that... is not exactly good
> > > interface. Think endianness issues  when writing to it from high-level
> > > language.
> > 
> > yeah.  At the moment I can't recall why I went binary for the ABI, 
> > we can revisit this, but its been in the wild for a few years now :(
> > 
> > I guess I can do some tricks to see if its a hex string representation
> > of a number and parse that as well as supporting the s32.  i.e. accept
> > strings "0x0000000" ... "0xFFFFFFFF" and return -EINVAL for anything
> > else.
> 
> Maybe you could use length for detection? If they are writing 4 bytes,
> it is s32, 10 bytes means ascii?

That is what I was thinking + making sure the chars in the string where
valid hex digits ;)  It would be easy to do.  Let me know if you think I
should attempt to roll that into the kernel ABI exposed by this thing.

--mgross


