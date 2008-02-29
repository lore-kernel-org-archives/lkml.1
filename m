Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYB2IzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYB2IzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 03:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYB2IzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 03:55:09 -0500
Received: from gv-out-0910.google.com ([216.239.58.189]:56724 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbYB2IzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 03:55:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qNwio0Gs/neJ9bywyib8aA5CBxqlKZ/JofLYjsgfbVUmnVT3C3L3WCN/hmM1/K/jmSkOdtFynvRtzaMU3zwj7VNHoPR6MM9DngDobu0L93OOpyFpRp+wNrm17W8NzW923DkRsyFL9UCeLVwzkTER4JtRQvAyfiUsWRBS8IlXjJI=
Message-ID: <ac8af0be0802290055m5ca1aa84yad6e38f6935f847@mail.gmail.com>
Date: Fri, 29 Feb 2008 16:55:05 +0800
From: "Zhao Forrest" <forrest.zhao@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Can Linux kernel handle unsynced TSC?
Cc: kvm-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for reposting it.

For example,
1 rdtsc() is invoked on CPU0
2 process is migrated to CPU1, and rdtsc() is invoked on CPU1
3 if TSC on CPU1 is slower than TSC on CPU0, can kernel guarantee
that the second rdtsc() doesn't return a value smaller than the one
returned by the first rdtsc()?

Thanks,
Forrest
