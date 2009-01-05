Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZAED6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZAED6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 22:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZAED63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 22:58:29 -0500
Received: from mail.lang.hm ([64.81.33.126]:46295 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZAED62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 22:58:28 -0500
Date: Sun, 4 Jan 2009 21:00:03 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Rob Landley <rob@landley.net>
cc: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@suse.cz>,
       Sitsofe Wheeler <sitsofe@yahoo.com>, Duane Griffin <duaneg@dghda.com>,
       Valdis.Kletnieks@vt.edu,
       =?ISO-8859-15?Q?Martin_MOKREJ=A6?= 
	<mmokrejs@ribosome.natur.cuni.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
In-Reply-To: <200901042149.27655.rob@landley.net>
Message-ID: <alpine.DEB.1.10.0901042058230.25545@asgard.lang.hm>
References: <fa.pmCH9X+XujDl6RH6/TpkNtsTnbk@ifi.uio.no> <20090104224052.GE1913@elf.ucw.cz> <20090104233052.GG22958@mit.edu> <200901042149.27655.rob@landley.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009, Rob Landley wrote:

> On Sunday 04 January 2009 17:30:52 Theodore Tso wrote:
>> On Sun, Jan 04, 2009 at 11:40:52PM +0100, Pavel Machek wrote:
>>> Not neccessarily.
>>>
>>> If I have a bit of precious data and lot of junk on the card, I want
>>> to copy out the precious data before the card dies. Reading the whole
>>> media may just take too long.
>>>
>>> That's probably very true for rotating harddrives after headcrash...
>>
>> For a small amount data, maybe; but the number of seeks is often far
>> more destructive than the amount of time the disk is spinning.  And in
>> practice, what generally happens is the user starts looking around to
>> make sure there wasn't anything else on the disk worth saving, and now
>> data is getting copied off based on human reaction time.  So that's
>> why I normally advise users that doing a full image copy of the disk
>> is much better than, say, "cp -r /home/luser /backup", or cd'ing
>> around a filesystem hierarchy and trying to save files one by one.
>
> That would be true if the disk hardware wasn't doing a gazillion retries to
> read a bad sector internally (taking 5 seconds to come back and report
> failure), and then the darn scsi layer added another gazillion retries on top
> of that, and the two multiply together to make it so slow that that when you
> leave the thing copying the disk overnight it's STILL not done 24 hours later.
> Going in and cherry picking individual files looks kind of appealing in that
> situation.

I've also had cases where one particular spot on the drive is bad. any 
attempt to read that sector fails and causes the drive to error out until 
a reboot. grabbing individual files I could skip the file(s) in the 
affected portion and retreive everything else on the drive (or in some 
cases raid array with multiple failures)

David Lang
