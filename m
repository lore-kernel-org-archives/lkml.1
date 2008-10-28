Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbYJ1SlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbYJ1SlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYJ1SlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:41:06 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:36174 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYJ1SlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:41:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UYvV//zPh7N2cXBycR119zwnU7B7ysj6+7TEwwG+veK4KkjkwMfmTBWuMDEFSxU0YI
         AvPMXWDiwBGsJMCb93hXyWWaP8LjhecARtQ0zf48nf2P4VuV8s29hhe/lTQEGlpnI+5x
         uNft4Fc9+QNrLIbQsynBKRyfnCs6RJ/DPsVXE=
Message-ID: <cd73a99e0810281141ief64433u85a55d045346d3fd@mail.gmail.com>
Date: Tue, 28 Oct 2008 20:41:00 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [patch 2.6.28-rc2] atmel_serial: keep clock off when it's not needed
Cc: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Nicolas Ferre" <nicolas.ferre@rfo.atmel.com>
In-Reply-To: <200810280920.19864.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810271406.24110.david-b@pacbell.net>
	 <20081028124526.6b9ccdf5@hskinnemo-gx745.norway.atmel.com>
	 <200810280920.19864.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi David,

> I verified it on AT91, where the console is normally DBGU and the
> other USARTs do get an open().

The DBGU is part of the system peripherals, which are clocked from MCK
and which is always enabled.
Therefore I don't think this is a valid test-case.


Regards,
  Andrew Victor
