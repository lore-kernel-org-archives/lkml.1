Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbXE3VSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbXE3VSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbXE3VSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:18:31 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:22499 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbXE3VSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:18:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=UIUDD9BGdcW/+A/455iO0IxUSXbU119SSXzMGwi49CaOCHJj6Zh3rlrtRHLdQatMGTQazMqiuFrN7aeQtoSZ1pdc8ciY3YqppfKf4Wgt+VjsaQ8Mcii7XtOQAAhZvtI0mTSwmdVu1qpXqrJ9+uT8zjRjKM0/BZ+IGx1T7nHBgm4=
Message-ID: <21d7e9970705301410m16ded9esdf7a49371c60a155@mail.gmail.com>
Date: Thu, 31 May 2007 07:10:52 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Linus Torvalds" <torvalds@osdl.org>, "Andi Kleen" <ak@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: GFP_DMA32 and PAE x86 machines
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just a question,

So we have GFP_DMA32 on x86-64 to gives us memory below 4G? so we not
have the same on PAE based x86 machines so I can use a consistent API
from the drm?

Otherwise it'll be stick some ifdefs in the drm to deal with it..

Dave.
