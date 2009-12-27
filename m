Return-Path: <linux-kernel-owner+w=401wt.eu-S1751353AbZL0VIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbZL0VIR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZL0VIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:08:16 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36600 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZL0VIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:08:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AzwbhHNO9o/mZzzf6lH0/Fe7GMfkTLQ+9laj29WRXvDZfSf28Qloi9KXZHjPBOHRMa
         xrFD8w8Mga/TkalfquZfG3GFaT123l2bsTZg6L220+mH1ngOrsotkRypz8jdHdUC0ezD
         dEyoytZg/HfSKd7U9PRVsS45u4nqTF1iOwXSk=
Message-ID: <4B37CD6A.2000506@gmail.com>
Date: Sun, 27 Dec 2009 22:11:06 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>,
       linux-parisc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] parisc: test off by one in sgl_frem() and dbl_frem()
References: <4B375F68.80301@gmail.com> <1261927804.2697.4.camel@mulgrave.site>
In-Reply-To: <1261927804.2697.4.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 27-12-09 16:30, James Bottomley schreef:
> On Sun, 2009-12-27 at 14:21 +0100, Roel Kluin wrote:
>> With `while (stepcount-- > 0)' stepcount reaches -1 after the loop.
> 
> This is true, but seems to be by design

>> -	if (stepcount > 0 || Sgl_iszero(opnd1)) {
>> +	if (stepcount >= 0 || Sgl_iszero(opnd1)) {

> 
> Your patch does nothing to the actual execution flow (Sgl_iszero is true
> if stepcount == 0) ... what's the point of applying it?
> 
> James

Ok, please ignore and thanks (also to Dave) for review.

Roel
