Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZBIOrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZBIOrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 09:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbZBIOrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 09:47:10 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:38988 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbZBIOrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:47:10 -0500
Subject: Re: 2.6.29-rc4: possible circular locking dependency at 
 btrfs_try_spin_lock
From: Chris Mason <chris.mason@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <a4423d670902090443v2c0da60g9c8ac4792586b044@mail.gmail.com>
References: <a4423d670902090443v2c0da60g9c8ac4792586b044@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 09:47:00 -0500
Message-Id: <1234190820.1262.0.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.499041E8.00A0:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 15:43 +0300, Alexander Beregalov wrote:
> Hi
> Is it false positive lockdep warning?
> 

Interesting, lockdep must be smarter in linux-next.  It's a false
positive, I'll try to fix it up.

-chris


