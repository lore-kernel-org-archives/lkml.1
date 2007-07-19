Return-Path: <linux-kernel-owner+w=401wt.eu-S1764170AbXGSU61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764170AbXGSU61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761598AbXGSU6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:58:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51569
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761458AbXGSU6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:58:02 -0400
Date: Thu, 19 Jul 2007 13:58:01 -0700 (PDT)
Message-Id: <20070719.135801.79067297.davem@davemloft.net>
To: airlied@gmail.com
Cc: akpm@linux-foundation.org, airlied@linux.ie, linux-kernel@vger.kernel.org
Subject: Re: cmpxchg is not available to generic code
From: David Miller <davem@davemloft.net>
In-Reply-To: <21d7e9970707190115r15e691d5s123c9889a8ebd8a5@mail.gmail.com>
References: <20070719000549.1e57b5b2.akpm@linux-foundation.org>
	<20070719.002716.30181989.davem@davemloft.net>
	<21d7e9970707190115r15e691d5s123c9889a8ebd8a5@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dave Airlie" <airlied@gmail.com>
Date: Thu, 19 Jul 2007 18:15:03 +1000

> Maybe we could add CONFIG_HAVE_CMPXCHG and let DRM depend on it..

There is already a "!EMULATED_CMPXCHG" guarding DRM, perhaps
ARM's Kconfig can set that if appropriate.
