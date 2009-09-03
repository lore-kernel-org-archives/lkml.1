Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbZICAaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbZICAaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 20:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbZICAaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 20:30:17 -0400
Received: from mail-iw0-f176.google.com ([209.85.223.176]:61046 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbZICAaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 20:30:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=nHUEKJjiI1t0EI6tZmKVFPgQfEvOoLCv89xZBv1lWpFWu+JDi1cI14m7y0mXCy9Yw3
         BIZMW/+SahhJ+Yzu0t8ChCNbypajimxxqDFnQDJprVzu/LopS23Gh2EImuk4etHe61L+
         MKvSjjv5KYY1wcm2mjKAesP/TrJVzLkFKq/bE=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 2 Sep 2009 17:29:57 -0700
Message-ID: <43e72e890909021729q7c40f907v7a81eaf5c8b73a61@mail.gmail.com>
Subject: Exporting kmemleak.h to userspace
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was reviewing kmemleak code and noticed kmemleak.h went exported to
userspace under include/linux/kmemleak.h. Do we expect userspace to
use this stuff somehow? All relevant kmemleak structs are kept
private, I'm curious what userspace apps would use this.

  Luis
