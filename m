Return-Path: <linux-kernel-owner+w=401wt.eu-S1751414AbZL1TfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbZL1TfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 14:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZL1TfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 14:35:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60393 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZL1TfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 14:35:05 -0500
Message-ID: <4B390836.70100@zytor.com>
Date: Mon, 28 Dec 2009 11:34:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Alain Knaff <alain@knaff.lu>, Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.33-rc1: LZMA kernel fails to decompress
References: <200912211643.18173.tvrtko.ursulin@sophos.com> <4B2FEC10.6050900@msgid.tls.msk.ru> <4B37AC87.1070607@knaff.lu> <4B37C159.5080202@msgid.tls.msk.ru>
In-Reply-To: <4B37C159.5080202@msgid.tls.msk.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2009 12:19 PM, Michael Tokarev wrote:
> 
> What I think should be done here is to revert my patch (that replaces
> /bin/echo with printf, so that /bin/echo will be used) and test the
> real solution, which is to stop doing all this hackery altogether,
> and calculate the size the right way instead.  Sam already posted a
> possible solution, and it seems to be correct.
> 

Yes, but it moves the calculation from generic to x86-specific code,
which makes it problematic.

I never figured out how to make a generic rule in Kbuild (unlike in
standard GNU make) depend on a helper application, but doing a helper
application for this is probably the sane thing.

Either this, or use Perl, which handles this kind of crap sanely.  I'm
really less than half joking.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

