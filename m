Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbYLPBkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbYLPBkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 20:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYLPBkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 20:40:03 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:48108 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbYLPBkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 20:40:00 -0500
Message-ID: <ac3eb2510812151739m1dc16d60u934c1ca02d45b401@mail.gmail.com>
Date: Tue, 16 Dec 2008 02:39:57 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Chris Mason" <chris.mason@oracle.com>
Subject: Re: Btrfs trees for linux-next
Cc: "Andreas Dilger" <adilger@sun.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <1229391447.27573.6.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	 <1228962896.21376.11.camel@think.oraclecorp.com>
	 <20081211141436.030c2d65.sfr@canb.auug.org.au>
	 <20081210200604.8e190b0d.akpm@linux-foundation.org>
	 <1229006596.22236.46.camel@think.oraclecorp.com>
	 <20081215210323.GB5000@webber.adilger.int>
	 <ac3eb2510812151455h27b790av9579b670edbca7ab@mail.gmail.com>
	 <1229391447.27573.6.camel@think.oraclecorp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 02:37, Chris Mason <chris.mason@oracle.com> wrote:
> On Mon, 2008-12-15 at 23:55 +0100, Kay Sievers wrote:
>> On Mon, Dec 15, 2008 at 22:03, Andreas Dilger <adilger@sun.com> wrote:
>> > On Dec 11, 2008  09:43 -0500, Chris Mason wrote:
>> >> The multi-device code uses a very simple brute force scan from userland
>> >> to populate the list of devices that belong to a given FS.  Kay Sievers
>> >> has some ideas on hotplug magic to make this less dumb.  (The scan isn't
>> >> required for single device filesystems).
>> >
>> > This should use libblkid to do the scanning of the devices, and it can
>> > cache the results for efficiency.  Best would be to have the same LABEL+UUID
>> > for all devices in the same filesystem, and then once any of these devices
>> > are found the mount.btrfs code can query the rest of the devices to find
>> > the remaining parts of the filesystem.
>>
>> Which is another way to do something you should not do that way in the
>> first place, just with a library instead of your own code.
>>
>
> Well, its the same library everyone else is using to do things they
> shouldn't be doing ;)

Util-linux-ng can be configured to use libvolume_id and udev data, and
it's not used in SUSE and Ubuntu for exactly the reason mentioned. :)

Kay
