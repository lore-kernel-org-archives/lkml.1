Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752950AbYLQV24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbYLQV24 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYLQV2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:28:32 -0500
Received: from acsinet14.oracle.com ([141.146.126.236]:58131 "EHLO
	acsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbYLQV2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:28:30 -0500
Subject: Re: Notes on support for multiple devices for a single filesystem
From: Chris Mason <chris.mason@oracle.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, adilger@sun.com,
        sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <ac3eb2510812171320i414d89d4x9840954275774d51@mail.gmail.com>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	 <1228962896.21376.11.camel@think.oraclecorp.com>
	 <20081211141436.030c2d65.sfr@canb.auug.org.au>
	 <20081210200604.8e190b0d.akpm@linux-foundation.org>
	 <1229006596.22236.46.camel@think.oraclecorp.com>
	 <20081215210323.GB5000@webber.adilger.int>
	 <20081217132343.GA14695@infradead.org>
	 <20081217115325.3312858a.akpm@linux-foundation.org>
	 <1229547485.27170.77.camel@think.oraclecorp.com>
	 <ac3eb2510812171320i414d89d4x9840954275774d51@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 16:26:24 -0500
Message-Id: <1229549184.27170.88.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet11.oracle.com [141.146.126.233]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49496EFA.00AC:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 22:20 +0100, Kay Sievers wrote:
> On Wed, Dec 17, 2008 at 21:58, Chris Mason <chris.mason@oracle.com> wrote:
> > On Wed, 2008-12-17 at 11:53 -0800, Andrew Morton wrote:
> >
> > There are other bits and pieces like high speed front end caching
> > devices that would be difficult in MD/LVM, but since I don't have that
> > coded yet I suppose they don't really count...
> 
> Features like the very nice and useful directory-based snapshots would
> also not be possible with simple block-based multi-devices, right?

At least for btrfs, the snapshotting is independent from the
multi-device code, and you still get snapshotting on single device
filesystems.

-chris


