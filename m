Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYKSUEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYKSUEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 15:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbYKSUEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 15:04:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:48874 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbYKSUEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 15:04:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition;
        b=aH8P6Vf9RQnL9MHwee0PxDP1fmAthRtVz2T8p0naj+wB0NdXezWw8jU3wzgS5hx5Jd
         DSEGDNmF6nAbi2oB0LzgQ2IX1wEpeBY6OFwiDtYAOmT0sINP8BNMfGz19oxsMWkAAqrx
         DhqHef/qWQ1H0Ywy5m2AdwG3qrHUcj09Gn/nk=
Message-ID: <cfd18e0f0811191204r4ccaeaf4m4145e67f408543e0@mail.gmail.com>
Date: Wed, 19 Nov 2008 15:04:22 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Serge Hallyn" <serue@us.ibm.com>
Subject: Current state of CLONE_NEWUSER?
Cc: "Subrata Modak" <subrata@linux.vnet.ibm.com>, ebiederm@xmission.com,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       clg@fr.ibm.com, herbert@13thfloor.at, dev@sw.ru
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Serge,

What is the current status of CLONE_NEWUSER?  I'm currently trying to
test this flag in preparation for documenting it in the clone(2) man
page, but am running into an ENOMEM error from the clone() call, which
seems to occur after a failure in kobject_init_and_add() in the
following call sequence:

clone_user_ns() --> alloc_uid() --> uids_user_create() -->
kobject_init_and_add()

Are there already some test programs somewhere?  Is there any
documentation already available for this flag?

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
