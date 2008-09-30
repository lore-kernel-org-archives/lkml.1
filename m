Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbYI3UFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbYI3UFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 16:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYI3UF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 16:05:26 -0400
Received: from nebensachen.de ([195.34.83.29]:46912 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbYI3UFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 16:05:25 -0400
X-Hashcash: 1:20:080930:linux-kernel@vger.kernel.org::RzuZhU8bGKWj+sIk:000000000000000000000000000000000CW43
From: Elias Oltmanns <eo@nebensachen.de>
To: linux-kernel@vger.kernel.org
Subject: Rounding conventions for jiffies_to_msecs / msecs_to_jiffies
Date: Tue, 30 Sep 2008 22:05:14 +0200
Message-ID: <8763od9z7p.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

since I don't really understand the algorithm in jiffies_to_msecs() for
HZ values that are not divisors or multiples of 1000 right now, I'd like
to ask if somebody can tell me something about it. In particular, I'd
like to know what we can assume wrt rounding, i.e. always round up /
down, etc. In fact, I'm most interested in the case where the argument
of jiffies_to_msecs() is close to zero. Can I safely assume that a
non-zero argument will *always* result in a non-zero return value
whatever HZ may be?

Even though I'm mostly concerned with jiffies_to_msecs() at the moment,
I am still intersted in the same questions wrt msecs_to_jiffies(), so
please don't shrink from an elaborate explanation ;-).

Thanks for all efforts in advance,

Elias
