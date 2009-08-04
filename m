Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZHDBXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZHDBXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 21:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbZHDBXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 21:23:37 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:56180 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZHDBXg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 21:23:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=O1IUWJosGkDs5em8criYWfDDaFrU4JChefVJX15awzOG1rFK2k2rbR1RhJzzAkGvef
         C3V9XDheh3tZ1OhA+j5yCkhyNOG6UbADFOs0hETw3V3zEYtlXZmP5B0iIY8Y+LtMmVho
         y859P6jTkkEFYYQwuzq9IR314prRAyq7VIdEg=
MIME-Version: 1.0
In-Reply-To: <24959.1249348108@turing-police.cc.vt.edu>
References: <24959.1249348108@turing-police.cc.vt.edu>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 3 Aug 2009 18:23:16 -0700
Message-ID: <43e72e890908031823s6049d51cl1a0dc523fb03e6e1@mail.gmail.com>
Subject: Re: 31-rc4-mmotm0730 - cfg80211 lockdep issues
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 3, 2009 at 6:08 PM, <Valdis.Kletnieks@vt.edu> wrote:
=======================================================
> [   60.656592] [ INFO: possible circular locking dependency detected ]

> [<ffffffff814a47ef>] regulatory_hint_11d+0x2b/0x574

Thanks for the report. I've sent patches for this, they are pending merge.

  Luis
