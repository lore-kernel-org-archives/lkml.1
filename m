Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbZDWSRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbZDWSRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 14:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbZDWSRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 14:17:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47237 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067AbZDWSRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 14:17:19 -0400
Message-ID: <49F0B09D.6040308@redhat.com>
Date: Thu, 23 Apr 2009 14:17:01 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>, Jarod Wilson <jarod@wilsonet.com>
Subject: [PATCH v4 0/2] crypto: add testmgr support and self-tests for rfc4309
References: <200904091434.59639.jarod@redhat.com> <200904150835.38818.jarod@redhat.com> <200904150935.15947.jarod@redhat.com> <200904150937.11979.jarod@redhat.com> <20090420062640.GB1135@gondor.apana.org.au>
In-Reply-To: <20090420062640.GB1135@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add necessary infrastructure additions to testmgr/tcrypt
to support the inclusion of rfc4309(ccm(aes)) self-tests, and the
rfc4309 test vectors themselves.

[PATCH 1/2] crypto: handle ccm dec test vectors expected to fail verification
[PATCH 2/2] crypto: add self-tests for rfc4309(ccm(aes))

Differences from prior submission:
- Patch 1 from the prior series dropped, as it turns out to be completely
unnecessary.
- Now using continue directly when expected ccm dec verify failures are
encountered, rather than wedging in an unneeded goto.

The self-tests patch itself remains unchanged.

-- 
Jarod Wilson
jarod@redhat.com
