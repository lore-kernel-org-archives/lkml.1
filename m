Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbYBRWJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbYBRWJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 17:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYBRWJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 17:09:22 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:49812 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbYBRWJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 17:09:21 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Gordon Farquharson" <gordonfarquharson@gmail.com>
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Date: Mon, 18 Feb 2008 23:08:56 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it, rmk@arm.linux.org.uk
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com>
In-Reply-To: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802182308.56789.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2008 23:03:10 Gordon Farquharson wrote:
> The b43 driver in 2.6.25-rc[12] fails to build for arm on an x86_64
> box using a cross-compiler:
> 
> FATAL: drivers/net/wireless/b43/b43: sizeof(struct ssb_device_id)=6 is
> not a modulo of the size of section __mod_ssb_device_table=64.
> Fix definition of struct ssb_device_id in mod_devicetable.h

Why does ARM have this special requirement and what is it about?

-- 
Greetings Michael.
