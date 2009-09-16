Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbZIPQoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbZIPQoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759909AbZIPQoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:44:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759911AbZIPQoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:44:22 -0400
Date: Wed, 16 Sep 2009 11:35:39 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 2.6.32
Message-ID: <20090916163538.GA5989@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull dlm updates for 2.6.32 from:

 git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

They have all been in linux-next for some time, and are all fixes related to
tcp connections.
Thanks,
Dave


Casey Dahlin (1):
      dlm: fix double-release of socket in error exit path

Lars Marowsky-Bree (1):
      dlm: fix connection close handling

Paolo Bonzini (1):
      dlm: use kernel_sendpage


 fs/dlm/lowcomms.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

