Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbZBYNni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbZBYNni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 08:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbZBYNnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 08:43:19 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:63854 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751274AbZBYNnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 08:43:18 -0500
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] Partial (de)compression Crypto API
Date: Wed, 25 Feb 2009 14:43:08 +0100
Message-Id: <1235569394-15217-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hi Herbert,

The following patch series adds support for partial (de)compression to the
CRYPTO API, and modifies SquashFS 4 to use this:

  - [1] netlink: Move netlink attribute parsing support to lib/
  - [2] crypto: compress - Add pcomp interface
  - [3] crypto: testmgr - Add support for the pcomp interface
  - [4] crypto: new zlib crypto module, using pcomp
  - [5] crypto: testmgr - add zlib test
  - [6] squashfs: Make SquashFS 4 use the new pcomp crypto interface

The patches are based on:
  linux-2.6.git + cryptodev-2.6.git

Changes since last version (2009-02-18):
  - Use netlink attributes for the (de)compression setup parameters
  - Move netlink attribute parsing support to lib/, enabled by CONFIG_NLATTR

David, Phillip: can I please have your ack?

If nobody objects, please apply.

Thanks!

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
