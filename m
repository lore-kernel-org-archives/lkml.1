Return-Path: <linux-kernel-owner+w=401wt.eu-S1751110AbZG0PIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110AbZG0PIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbZG0PIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:08:00 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48534 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZG0PH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:07:59 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: linux-next: drbd tree build failure
Date: Mon, 27 Jul 2009 17:07:58 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090727173754.6a04e781.sfr@canb.auug.org.au> <200907271109.33271.philipp.reisner@linbit.com> <a4423d670907270438n3e8f07caoa45124b1bd7b2386@mail.gmail.com>
In-Reply-To: <a4423d670907270438n3e8f07caoa45124b1bd7b2386@mail.gmail.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907271707.58733.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009 13:38:44 Alexander Beregalov wrote:
> One more issue
>
> drivers/block/drbd/drbd_main.c: In function 'drbd_buildtag':
> drivers/block/drbd/drbd_main.c:3738: error: dereferencing pointer to
> incomplete type

Ohh, right. I have never tried to build a kernel with the DRBD patch
without CONFIG_MODULES set.

It is fixed now.

-Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

