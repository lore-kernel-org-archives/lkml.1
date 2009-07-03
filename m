Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbZGCNd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbZGCNd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 09:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbZGCNdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 09:33:17 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:64556 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbZGCNdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 09:33:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=qyDP5EtfysOFRkczESo016JzRe+kyuRPTcPzsr2qU+dBTwKvK3bU60jcUOfSebx2Q/
         kgFdeX3SDQyUPGC4FIy99L20rmXPYZpD7xTFjE/eN+s1fR6tNiFcRupPoir/u0um+KaK
         fZM696Sk0TFi7PolflVDSOcnVwKX/8TVwEcIs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [PATCH] Staging: vt6656: remove dependency on WIRELESS_EXT version
Date: Fri, 3 Jul 2009 15:39:20 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc1-next-20090703-03460-gb01c1b8; KDE/4.2.4; i686; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, forest@alittletooquiet.net
References: <1246615634-14939-1-git-send-email-a.beregalov@gmail.com>
In-Reply-To: <1246615634-14939-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907031539.20778.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 July 2009 12:07:14 Alexander Beregalov wrote:
> As the driver is in mainline now we can remove such dependency.
> WIRELESS_EXT is 22 now and it is always defined.
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

That was fast. :)

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

BTW:

* It seems that both vt665x drivers should just select WIRELESS_EXT in
  their Kconfig's and then we can remove all remaining CONFIG_WIRELESS_EXT
  ifdefs.

* vt6656 probably also needs to depend on USB.

Alexander, could you look into it?

Thanks.
Bart
