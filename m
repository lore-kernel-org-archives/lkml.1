Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbYDAV1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbYDAV1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYDAV1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:27:09 -0400
Received: from 1wt.eu ([62.212.114.60]:1088 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406AbYDAV1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:27:08 -0400
Date: Tue, 1 Apr 2008 23:26:52 +0200
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Artem Bityutskiy <dedekind@yandex.ru>, Andi Kleen <andi@firstfloor.org>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       ext-adrian.hunter@nokia.com, jwboyer@gmail.com
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
Message-ID: <20080401212652.GD23796@1wt.eu>
References: <47F1EC20.6050600@wpkg.org> <47F1F644.4060000@yandex.ru> <878wzx25s7.fsf@basil.nowhere.org> <47F21B47.4000206@yandex.ru> <47F26278.5070009@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F26278.5070009@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 09:27:36AM -0700, H. Peter Anvin wrote:
> Artem Bityutskiy wrote:
> >Andi Kleen wrote:
> >>Artem Bityutskiy <dedekind@yandex.ru> writes:
> >>
> >>>Tomasz Chmielewski wrote:
> >>>>For me, the motivators to wait for LogFS are mainly the facts that it
> >>>>can work on traditional block devices, and not only on pure flash:
> >>>Sorry Thomasz, for me this makes zero sense. There are _much_ better 
> >>>file
> >>>systems for block devices.
> >>
> >>I think he refers to flash disks appearing as block devices, like
> >>usb sticks or similar.
> >
> >Right, I also meant that in my opinion it makes more sense to use 
> >traditional
> >file-systems like ext3 on USB-key/MMC and the like stuff (which I 
> >confusingly
> >referred as "block devices"), or may be something more "heavy-weight" like
> >XFS or JFS (never tried them, though).
> >
> 
> Well, even auto-levelling storage should benefit from a filesystem which 
> minimizes the total number of flash sectors churned, which means doing 
> as few writes as possible and to large, contiguous sections.

Exactly. At exosec, we ship one appliance which writes statistics to a
partition on a compactflash every 5 minutes. We preferred to go with JFFS2
exactly because of this reason. We never had any problem proceeding this way.
I'm not sure if it would have been the same with ext2 though.

Willy

