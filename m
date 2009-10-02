Return-Path: <linux-kernel-owner+w=401wt.eu-S1752415AbZJBESI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbZJBESI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 00:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZJBESI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 00:18:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48219 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbZJBESH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 00:18:07 -0400
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, yehuda@newdream.net
Subject: Re: [PATCH 19/21] ceph: ioctls
From: Andi Kleen <andi@firstfloor.org>
References: <1253641129-28434-1-git-send-email-sage@newdream.net>
	<1253641129-28434-2-git-send-email-sage@newdream.net>
	<1253641129-28434-3-git-send-email-sage@newdream.net>
	<1253641129-28434-4-git-send-email-sage@newdream.net>
	<1253641129-28434-5-git-send-email-sage@newdream.net>
	<1253641129-28434-6-git-send-email-sage@newdream.net>
	<1253641129-28434-7-git-send-email-sage@newdream.net>
	<1253641129-28434-8-git-send-email-sage@newdream.net>
	<1253641129-28434-9-git-send-email-sage@newdream.net>
	<1253641129-28434-10-git-send-email-sage@newdream.net>
	<1253641129-28434-11-git-send-email-sage@newdream.net>
	<1253641129-28434-12-git-send-email-sage@newdream.net>
	<1253641129-28434-13-git-send-email-sage@newdream.net>
	<1253641129-28434-14-git-send-email-sage@newdream.net>
	<1253641129-28434-15-git-send-email-sage@newdream.net>
	<1253641129-28434-16-git-send-email-sage@newdream.net>
	<1253641129-28434-17-git-send-email-sage@newdream.net>
	<1253641129-28434-18-git-send-email-sage@newdream.net>
	<1253641129-28434-19-git-send-email-sage@newdream.net>
	<1253641129-28434-20-git-send-email-sage@newdream.net>
Date: Fri, 02 Oct 2009 06:18:08 +0200
In-Reply-To: <1253641129-28434-20-git-send-email-sage@newdream.net> (Sage Weil's message of "Tue, 22 Sep 2009 10:38:47 -0700")
Message-ID: <87ske2sa2n.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage Weil <sage@newdream.net> writes:
> +/*
> + * Extract identity, address of the OSD and object storing a given
> + * file offset.
> + */
> +struct ceph_ioctl_dataloc {
> +	__u64 file_offset;           /* in+out: file offset */
> +	__u64 object_offset;         /* out: offset in object */
> +	__u64 object_no;             /* out: object # */
> +	__u64 object_size;           /* out: object size */
> +	char object_name[64];        /* out: object name */
> +	__u64 block_offset;          /* out: offset in block */
> +	__u64 block_size;            /* out: block length */
> +	__s64 osd;                   /* out: osd # */
> +	struct sockaddr_in osd_addr; /* out: osd address */

You'll have to revise that once you support IPv6. At least extend the structure
better now? (_in is too small for IPv6)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
