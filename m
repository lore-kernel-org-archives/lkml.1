Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbYJQEHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbYJQEHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 00:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbYJQEHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 00:07:20 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:11069 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYJQEHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 00:07:19 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=NA7lkLqEx1kZuc4n_VwA:9 a=ZXCaYQ2dudE6EQHVfTLC_htwPc0A:4 a=IOF2C89_OicA:10 a=WdjdgcVRjsYA:10
Message-ID: <48F80F6F.6090608@shaw.ca>
Date: Thu, 16 Oct 2008 22:07:11 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Len Brown <lenb@kernel.org>,
       "Brown, John M (WGBU R&D)" <john.brown3@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI suspend: Blacklist HP xw4600 Workstation for old
 code ordering
References: <fa./6DR3VeG3JltQZvwctIdnZpBOO8@ifi.uio.no> <fa.TMVI/3KJQDTBIWAfYmLw01GczF4@ifi.uio.no> <fa./GCX/x0zwCB6BIEvtQehNpVDSVk@ifi.uio.no> <fa.MkpTJy5Iw9ZR3PXWpugQeK5oN1o@ifi.uio.no>
In-Reply-To: <fa.MkpTJy5Iw9ZR3PXWpugQeK5oN1o@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Wednesday, 15 of October 2008, Len Brown wrote:
>> Matthew,
>> You are right, of course, we're not doing something right
>> if a new machine needs this workaround.
> 
> Isn't that possible, however, that the BIOS of this new machine is based on an
> older one that used to have this problem?

Maybe, but it doesn't matter. If it's a new machine it's presumably 
going to work fine on Vista, etc. so it doesn't make much sense that 
this machine should require the old ACPI code ordering.
