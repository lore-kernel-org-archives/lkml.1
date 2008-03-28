Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbYC1TXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbYC1TXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYC1TXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:23:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:38714 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbYC1TXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:23:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OzgaZ6mH6m2PeOxlqewJBjwkN6ATKx2Eq7Kd0xWkWhgvOYn/lSHHiPRnbgz7IaPy1l85YKiFfzkPEZ1G5G+DhPvKUv/B66tJt7z91X0lAH8q6UQ8/XvFVoPDX3/iEJSt8MBNnECAhYrTgfbcFUwOtsho+2X7tIDd9ruV0ZFLqOY=
Message-ID: <524f69650803281223v5e54e1c1na8a46da2e0a3df4c@mail.gmail.com>
Date: Fri, 28 Mar 2008 14:23:12 -0500
From: "Steve French" <smfrench@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Can kmem_cache_free block?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is kmem_cache_free safe to call while holding a spinlock (can
kmem_cache_free ever block or recurse into a file system)?

I see it trying to grab just another spinlock which is probably fine
(but was worried whether any of the worker functions called a sem) ...
my assumption is that it would be safe, but the man page doesn't
mention when it can be used safely.

-- 
Thanks,

Steve
