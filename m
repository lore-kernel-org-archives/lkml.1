Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbZHCVDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbZHCVDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZHCVDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:03:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34259 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbZHCVDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:03:49 -0400
Message-ID: <4A77509A.3010401@zytor.com>
Date: Mon, 03 Aug 2009 14:03:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: MAINTAINERS: standardize James Bottomley's name
References: <1249331570.5149.48.camel@Joe-Laptop.home> <1249332233.3943.211.camel@mulgrave.site>
In-Reply-To: <1249332233.3943.211.camel@mulgrave.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2009 01:43 PM, James Bottomley wrote:
> On Mon, 2009-08-03 at 13:32 -0700, Joe Perches wrote:
>> His recent patches and sign-offs have not used "E.J."
>>
>> This reduces the likelihood that get_maintainers.pl will
>> list his address twice.
> 
> It is standard:  I like my initials; which, per RFC requires the quotes
> because it's a mailing address.
> 

It's not actually required by RFC 2822.

The relevant productions are:

name-addr       =       [display-name] angle-addr
display-name    =       phrase
phrase          =       1*word / obs-phrase
obs-phrase      =       word *(word / "." / CFWS)

Now, obs- usually indicates an obsolete (deprecated
backwards-compatibility) production, but the text states:

   Note: The "period" (or "full stop") character (".") in obs-phrase is
   not a form that was allowed in earlier versions of this or any other
   standard.  Period (nor any other character from specials) was not
   allowed in phrase because it introduced a parsing difficulty
   distinguishing between phrases and portions of an addr-spec (see
   section 4.4).  It appears here because the period character is
   currently used in many messages in the display-name portion of
   addresses, especially for initials in names, and therefore must be
   interpreted properly.  In the future, period may appear in the
   regular syntax of phrase.

	-hpa
