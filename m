Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbYA3GMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbYA3GMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 01:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbYA3GMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 01:12:47 -0500
Received: from c60.cesmail.net ([216.154.195.49]:41253 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbYA3GMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 01:12:46 -0500
Message-ID: <20080130011245.9ns4zafum84ck88k@webmail.spamcop.net>
Date: Wed, 30 Jan 2008 01:12:45 -0500
From: Pavel Roskin <proski@gnu.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jon Masters <jonathan@jonmasters.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
Subject: Re: ndiswrapper and GPL-only symbols redux
References: <1201641765.18773.35.camel@dv> <20080129224529.4b8016c3@core>
	<1201651006.23553.8.camel@dv> <p73bq746lml.fsf@bingen.suse.de>
	<20080130050721.GB22444@dallas.jonmasters.org> <1201670805.4382.4.camel@rd>
	<p734pcv7sva.fsf@bingen.suse.de>
In-Reply-To: <p734pcv7sva.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andi Kleen <andi@firstfloor.org>:

> Pavel Roskin <proski@gnu.org> writes:
>>   */
>> @@ -162,6 +163,7 @@ const char *print_tainted(void)
>>  	if (tainted) {
>>  		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c",
>>  			tainted & TAINT_PROPRIETARY_MODULE ? 'P' : 'G',
>> +			tainted & TAINT_BLOB_WRAPPER ? 'W' : ' ',
>
>
> Are you sure you don't need to add a new '%c' to the format string too?
> I think gcc should have warned.

You are right!  Thanks.

-- 
Regards,
Pavel Roskin
