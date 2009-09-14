Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbZINM2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbZINM2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 08:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbZINM17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 08:27:59 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42159 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753179AbZINM16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:27:58 -0400
Date: Mon, 14 Sep 2009 14:27:57 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: recent bdi changes result in WARN_ON on luksClose / dm
Message-ID: <20090914122757.GA29613@Chamillionaire.breakpoint.cc>
References: <20090912111928.GA8013@Chamillionaire.breakpoint.cc>
 <20090912195212.GF14984@kernel.dk>
 <20090912195839.GG14984@kernel.dk>
 <20090913091337.GA21969@Chamillionaire.breakpoint.cc>
 <20090913175717.GO14984@kernel.dk>
 <20090914090533.GU14984@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090914090533.GU14984@kernel.dk>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe | 2009-09-14 11:05:33 [+0200]:

>I think the safest option is to ensure that we just move these entries
>to our default bdi, which doesn't go away. This should fix the warning,
>can you test whether it works as well?
Yep, I don't see anything with this patch. Thanks.

Sebastian
