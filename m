Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbXEZF4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbXEZF4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 01:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbXEZF4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 01:56:09 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbXEZF4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 01:56:08 -0400
Message-ID: <4657CBEC.7070609@zytor.com>
Date: Fri, 25 May 2007 22:55:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Auke Kok <auke-jan.h.kok@intel.com>, Andy Whitcroft <apw@shadowen.org>,
       "Randy.Dunlap" <rdunlap@xenotime.net>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] scripts: Make cleanfile/cleanpatch warn about long lines
References: <200705260100.l4Q10e05030097@tazenda.hos.anvin.org> <20070525224124.5d0a310b.akpm@linux-foundation.org>
In-Reply-To: <20070525224124.5d0a310b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 25 May 2007 17:58:26 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> Make the "cleanfile" and "cleanpatch" script warn about long lines,
>> by default lines whose visual width exceeds 79 characters.
>>
>> Per suggestion from Auke Kok.
>>
>> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>> ---
>>  scripts/cleanfile  |   54 ++++++++++++++++++++++++++++++++++++++++++++++-
>>  scripts/cleanpatch |   58 +++++++++++++++++++++++++++++++++++++++++++++++++--
> 
> This functionality wholly duplicates the patch-sanity-checking script
> which Andy, Randy and others are working on.
> 
> The plan is to merge that script into the tree and, once it's looking
> reasonably accurate, we wire a copy of it up to the email lists so that it
> autonags patch-senders over the usual trivial junk.  Think of it as an
> akpm-over-SMTP server.

LOL.

	-hpa
