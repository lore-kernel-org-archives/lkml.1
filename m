Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZDZDsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZDZDsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 23:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZDZDsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 23:48:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:57934 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbZDZDsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 23:48:08 -0400
Message-ID: <49F3D994.7020304@kernel.org>
Date: Sun, 26 Apr 2009 12:48:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: unsik Kim <donari75@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mg_disk: fix dependency on libata
References: <200904251509.11912.bzolnier@gmail.com>
In-Reply-To: <200904251509.11912.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 26 Apr 2009 03:47:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Add local copies of ata_id_string() and ata_id_c_string() to mg_disk
> so there is no need for the driver to depend on ATA and SCSI.
> 
> Cc: unsik Kim <donari75@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Ah.. right, that's a rather large dependency to pull in just for the
string functions.  Yeah, I think it would be better to keep local
copy at elast for now.

Acked-by: Tejun Heo <tj@kernel.org>

(Continuing from the previous message :-) or do you want me to fold
these patches into my series and push them through Jens with other
patches?

Thanks.

-- 
tejun
