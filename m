Return-Path: <linux-kernel-owner+w=401wt.eu-S1752227Ab0AWVf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab0AWVf5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 16:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995Ab0AWVf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 16:35:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59252 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab0AWVf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 16:35:56 -0500
Date: Sat, 23 Jan 2010 13:35:39 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: dhowells@redhat.com, adkulkar@umail.iu.edu
Subject: NFS_FSCACHE still depends on EXPERIMENTAL?
Message-ID: <alpine.DEB.2.01.1001231314480.3483@bogon.housecafe.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19eCiE9n0GEfY9soEz6C/gGvdGnT2KD1noHVqm
 9NMPKITwBHECmMM5gay/bPzv72HEU9XBtWiL0FevD6PQM73e7r
 HjbyX92FXxv07AdjeKmjQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

there's currently an open Ubuntu bug[0], with the intent to compile 
NFS_FSCACHE (and possibly AFS_FSCACHE, 9P_FSCACHE) into the standard 
Ubuntu kernel. However, since *_FSCACHE still depends on EXPERIMENTAL, 
this won't happen.

I'd like to know if the EXPERIMENTAL tag is still needed for these 
options and if so, what would be needed to remove this tag. Removing this 
tag would allow Ubuntu to include these features into its kernel, possibly 
allowing an even greater userbase to test these features, hopefully providing 
feedback.

Thanks,
Christian.

[0] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/440522/comments/5
-- 
BOFH excuse #259:

Someone's tie is caught in the printer, and if anything else gets printed, he'll be in it too.
