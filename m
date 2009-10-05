Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbZJEBRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbZJEBRG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 21:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757624AbZJEBRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 21:17:05 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:60480 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbZJEBRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 21:17:05 -0400
Date: Mon, 5 Oct 2009 03:16:27 +0200
To: linux-kernel@vger.kernel.org
Subject: complete IO hang since a few kernel revision
Message-ID: <20091005011626.GH4335@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

(please Cc)

kernel 2.6.31.1, 2.6.31.2rc1, 2.6.31, 2.6.30 (at least)
Intel Corporation ICH9M/M-E SATA AHCI


I am experiencing IO stalls of real serious dimensions. I mean up to 20secs
waiting for some operations.

That normally happeny when I do a svn up on a big subversion repository,
but even on other locations.

Yesterday a simple sync took 30sec although I was not doing anything else.

I am *quite* sure that it wasn't like that in former kernel revisions, but
I don't have old ones at hand for testing.

Is there something known about a regression in this area?

Sorry for not Cc-ing the right people, didn't know who it could be.

Thanks a lot for any help/remarks/suggestions

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining                                        Associate Professor
JAIST Japan Advanced Institute of Science and Technology   preining@jaist.ac.jp
Vienna University of Technology                               preining@logic.at
Debian Developer (Debian TeX Task Force)                    preining@debian.org
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
QUOYNESS (n.)
The hatefulness of words like 'relionus' and 'easiephit'.
			--- Douglas Adams, The Meaning of Liff
