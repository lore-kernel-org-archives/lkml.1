Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbYBZMWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbYBZMWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 07:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYBZMWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 07:22:33 -0500
Received: from sorrow.cyrius.com ([65.19.161.204]:3585 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbYBZMW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 07:22:29 -0500
Date: Tue, 26 Feb 2008 13:21:00 +0100
From: Martin Michlmayr <tbm@cyrius.com>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: 2.6.25-rc3: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
Message-ID: <20080226122100.GB22699@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.25-rc3 and a config file with

CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y

I get the following build error on at least ARM and MIPS:

  Building modules, stage 2.
  MODPOST 759 modules
ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!

-- 
Martin Michlmayr
http://www.cyrius.com/
