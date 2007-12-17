Return-Path: <linux-kernel-owner+w=401wt.eu-S1756294AbXLQNG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbXLQNG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbXLQNGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:06:52 -0500
Received: from hu-out-0506.google.com ([72.14.214.227]:62762 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbXLQNGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:06:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=resent-from:resent-date:resent-message-id:resent-to:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=C5/fNRu8DRHa3lC6MmeIKRFwsJS3A4k8FGBJkMYq8a4P+lAvX2766PxC5GNpnC4wP9ZN7mc/rdIsThA1/0E59nwoGRE5d61i2BLNP2xHq4vI1GyjK0ZzHZyrU4SGmiF1x0ZLSgT2t84ZVD7M6JOFUTRucLzE2i8JEO9Ic3eVlSQ=
Date: Mon, 17 Dec 2007 16:01:07 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: lockdep hashes
Message-ID: <20071217130107.GA7389@cvg.cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

i'm quite sorry for annoying you with my stupid question but
i don't know whom to ask about lockdep hashes (you're the
author right?). Ingo look the code has

#define iterate_chain_key(key1, key2) \
	(((key1) << MAX_LOCKDEP_KEYS_BITS) ^ \
	((key1) >> (64-MAX_LOCKDEP_KEYS_BITS)) ^ \
	(key2))

but from where this function math is taken? How dod you find
it? (I read Knuth about hash functions and about prime numbers).
Or this is an experience who shows you the right hashing formula?
Could you point me in which direction i shoul to digg to understand this?

		Cyrill

