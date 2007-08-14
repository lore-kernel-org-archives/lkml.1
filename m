Return-Path: <linux-kernel-owner+w=401wt.eu-S936975AbXHNW6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936975AbXHNW6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936064AbXHNWzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:55:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:53925 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934457AbXHNWzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:55:06 -0400
Subject: Re: [RFC 0/3] dm: add path uevents
From: Kay Sievers <kay.sievers@vrfy.org>
To: Mike Anderson <andmike@us.ibm.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
In-Reply-To: <20070814200544.963756967@us.ibm.com>>
References: <20070814200544.963756967@us.ibm.com>>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 00:58:34 +0200
Message-Id: <1187132314.4312.47.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18WYAQRTE+ITL6X1QNs+jxtCKkdaQB3OLN2Ri0
 ULungpXtl/BUDrsoV11qeUqaFbUIYvSi/za/A3vHwDTuoUO4IY
 tt72msouWbJPjZ2/Y8iU7zripfzKPy+
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 13:05 -0700, Mike Anderson wrote:
> This patch series enables device mapper (dm) to send kobject uevents for
> dm events. Currently only two new events are sent related to path state
> changes.

Sounds fine.

> DM_ACTION=PATH_FAILED
> DM_SEQNUM=1
> DM_PATH=8:48
> DM_PATHS=1

Oh, I have a patch pending for dmsetup to export a bunch of variables in
the environment format with a single call, so we can use it udev
context.
Here is the list, just that we don't clash with names or use the same
names where appropriate:
  DM_NAME=
  DM_UUID=
  DM_STATE=
  DM_TABLE_STATE=
  DM_OPENCOUNT=
  DM_MAJOR=
  DM_MINOR=
  DM_TARGET_COUNT=
  DM_TARGET_TYPES=
  DM_LAST_EVENT_NR=

Let me know if something should be renamed.

Thanks,
Kay

