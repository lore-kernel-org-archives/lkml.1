Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbZGUU22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbZGUU22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbZGUU21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:28:27 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:37977 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZGUU20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:28:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f4jf+gvUaEIz1NJVgKdXQFkeczIZWyhUdngxlqg3c3niCWtgeji3T4LK8yH0iq0cc2
         708hi1J/uYpeYsTWGobEU7TqhZgxumkzvv1NKPHNzmWD3MCugxA3MYnAvHwUoddyXzpn
         Rljkoa9Nih2xtxxt00Q1DHQHFte94Jt9kB8bA=
MIME-Version: 1.0
In-Reply-To: <1248128808-2241-1-git-send-email-linus.walleij@stericsson.com>
References: <1248128808-2241-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 21 Jul 2009 22:28:25 +0200
Message-ID: <63386a3d0907211328v3c060012r3acc2d5f88e4d9eb@mail.gmail.com>
Subject: Re: [PATCH 1/2] MMC Agressive clocking framework v5
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pierre Ossman <pierre@ossman.eu>,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then the ChangeLog I missed yesterday due to sitting up too
late:

ChangeLog v4->v5:

* Make mmc_set_data_timeout() in core.c work even if ios.clock is
  set to zero by the clock gating code.

* Give the host-centric functions the mmc_host_clk* prefix instead
  so it is clear that it's host functionality that is being
  called.

* Mailing this to Andrew Morton and LKML since the previous MMC
  maintainer stepped down.

Linus Walleij
