Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbYA2W5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbYA2W5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYA2W50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:57:26 -0500
Received: from bay0-omc2-s35.bay0.hotmail.com ([65.54.246.171]:34633 "EHLO
	bay0-omc2-s35.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753555AbYA2W5Z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:57:25 -0500
Message-ID: <BAY101-W250E57C799BED87E221785C8350@phx.gbl>
X-Originating-IP: [76.197.179.236]
From: Adam Turk <bofh1234@hotmail.com>
To: Gene Heskett <gene.heskett@gmail.com>
CC: <linux-kernel@vger.kernel.org>
Subject: RE: Problem with ata layer in 2.6.24
Date: Tue, 29 Jan 2008 17:57:24 -0500
Importance: Normal
In-Reply-To: <200801291255.59375.gene.heskett@gmail.com>
References: <BAY101-W159C6F9F2C09199889AA3C8350@phx.gbl>
 <200801291255.59375.gene.heskett@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Jan 2008 22:57:24.0878 (UTC) FILETIME=[50375AE0:01C862CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: gene.heskett@gmail.com
>>if this works then it really needs to move and be renamed. I am compiling
>> with DEV_SR set.
>>
> That fixed me right up, Adam, & k3b is once again as happy as a clam.

Fixed it for me too.  I just realized the default config in 2.6.24 is way different than the default config in 2.6.23.  

If I remember correctly there was talk of separating the libata and scsi code.  This was awhile ago.  I am not a kernel programmer, only a user, but either the scsi and libata kconfig menus should be joined and made generic, or options like cdrom support should be in both kconfig menus.  Alan says libata is scsi with an accent so maybe merging the two isn't as bad as it sounds.  

Just my $0.02 cents, probably worth less in this case.
Adam
_________________________________________________________________
Connect and share in new ways with Windows Live.
http://www.windowslive.com/share.html?ocid=TXT_TAGHM_Wave2_sharelife_012008