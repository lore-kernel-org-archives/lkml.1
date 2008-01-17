Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbYAQS1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbYAQS1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYAQS1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:27:07 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:19054 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbYAQS1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:27:05 -0500
From: Chris mason <chris.mason@oracle.com>
To: btrfs-devel@oss.oracle.com
Subject: Re: [Btrfs-devel] [ANNOUNCE] Btrfs v0.10 (online growing/shrinking, ext3 conversion, and more)
Date: Thu, 17 Jan 2008 13:25:55 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20080115105238.4fc3e992@think.oraclecorp.com>
In-Reply-To: <20080115105238.4fc3e992@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801171325.55406.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2008, Chris Mason wrote:
> Hello everyone,
>
> Btrfs v0.10 is now available for download from:
>
> http://oss.oracle.com/projects/btrfs/

Well, it turns out this release had a few small problems:

* data=ordered deadlock on older kernels (including 2.6.23)
* Compile problems when ACLs were not enabled in the kernel

So, I've put v0.11 out there.  It fixes those two problems and will also 
compile on older (2.6.18) enterprise kernels.

v0.11 does not have any disk format changes.

-chris


