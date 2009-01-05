Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZAEOPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZAEOPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZAEOPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:15:23 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:44903 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbZAEOPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:15:22 -0500
Subject: Re: Btrfs for mainline
From: Chris Mason <chris.mason@oracle.com>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
In-Reply-To: <20090103.184406.54858118.ryusuke@osrg.net>
References: <1230765549.7538.8.camel@think.oraclecorp.com>
	 <20090103.013755.42849152.ryusuke@osrg.net>
	 <1230925087.7538.41.camel@think.oraclecorp.com>
	 <20090103.184406.54858118.ryusuke@osrg.net>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 09:14:56 -0500
Message-Id: <1231164896.4290.19.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.496215E8.0188:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-03 at 18:44 +0900, Ryusuke Konishi wrote:
> On Fri, 02 Jan 2009 14:38:07 -0500, Chris Mason 
>
> Btrfs seems to have other helpful code including pages/bio compression
> which may become separable, too.  And, this may be the same for
> pages/bio encryption/decryption code which would come next.  (I don't
> mention about the volume management/raid feature here to avoid getting
> off the subject, but it's likewise).
> 

The compression code is somewhat tied to the btrfs internals, but it
could be pulled out without too much trouble.  The big question there is
if other filesystems are interested in transparent compression support.

But, at the end of the day, most of the work is still done by the zlib
code.  The btrfs bits just organize pages to send down to zlib.

-chris


