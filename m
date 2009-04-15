Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZDONgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZDONgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 09:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbZDONgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 09:36:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39757 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbZDONgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 09:36:01 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/3] crypto: add testmgr support and self-tests for rfc4309
Date: Wed, 15 Apr 2009 09:35:15 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.29.1-54.fc11.x86_64; KDE/4.2.2; x86_64; ; )
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
References: <200904091434.59639.jarod@redhat.com> <20090415112053.GA10188@gondor.apana.org.au> <200904150835.38818.jarod@redhat.com>
In-Reply-To: <200904150835.38818.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904150935.15947.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds necessary fix-ups and infrastructure additions to
testmgr/tcrypt to support the inclusion of rfc4309(ccm(aes)) self-tests,
and finally, the rfc4309 test vectors themselves.

[PATCH 1/3] crypto: properly handle null input and assoc data aead test vectors
[PATCH 2/3] crypto: handle ccm dec test vectors expected to fail verification
[PATCH 3/3] crypto: add self-tests for rfc4309(ccm(aes))

-- 
Jarod Wilson
jarod@redhat.com
