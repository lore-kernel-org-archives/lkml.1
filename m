Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZINMs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZINMs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 08:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbZINMsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 08:48:25 -0400
Received: from rtr.ca ([76.10.145.34]:49024 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbZINMsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:48:24 -0400
Message-ID: <4AAE3B9A.2060306@rtr.ca>
Date: Mon, 14 Sep 2009 08:48:26 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tejun Heo <teheo@suse.de>
Cc: Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org,
       Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
References: <92cb16daad8278b0aa98125b9e1d057a@localhost> <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost> <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com> <4A9B8583.9050601@kernel.org> <4A9BBC4A.6070708@redhat.com> <4A9BC023.10903@kernel.org> <20090907114442.GG18831@arachsys.com> <20090907115927.GU8710@arachsys.com> <20090909120218.GB21829@arachsys.com> <4AADF3C4.5060004@kernel.org> <4AADF471.2020801@suse.de>
In-Reply-To: <4AADF471.2020801@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
..
> Oooh, another possibility is the above continuous IDENTIFY tries.
> Doing things like that generally isn't a good idea because vendors
> don't expect IDENTIFY to be mixed regularly with normal IOs and
> firmwares aren't tested against that.  Even smart commands sometimes
> cause problems.  So, finding out the thing which is obsessed with the
> identity of the drive and stopping it might help.
..

Bullpucky.  That sort of thing, specifically with IDENTIFY,
has never been an issue.

I wonder if the IDENTIFY is actually coming from libata EH
after something else failed ?
