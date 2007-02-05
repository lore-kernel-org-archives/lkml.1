Return-Path: <linux-kernel-owner+w=401wt.eu-S965059AbXBEXVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965059AbXBEXVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 18:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965065AbXBEXVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 18:21:24 -0500
Received: from wx-out-0506.google.com ([66.249.82.232]:34881 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965059AbXBEXVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 18:21:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=G570d9PfT99r9Xuu/jy82DdQBtibWFUJBKmb3U+PTyBO/lU2nfjjaPZNk8wzclI2Y/m8xQA7zsz26O2MGA8KUb3JhLfTwSM6CdaswDLl29wu3yKbBkNISYiMe1/L5LLs28m46avVBZsZZ7DQCv8C5wTcdRd6ai7BZ4gw9EIxk8U=
Message-ID: <e6babb600702051521l4a08eb2dw2a7f423fd0d7edd7@mail.gmail.com>
Date: Mon, 5 Feb 2007 16:21:22 -0700
From: "Robert Crocombe" <rcrocomb@gmail.com>
To: linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: ohci1394 broke 2.6.19 -> 2.6.20-rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to testing a patch for bugzilla bug 7569 (hosts lost on bus
reset), I wanted to reproduce the behavior.  I can under the noted
2.6.16-blah kernels, but moving to anything more recent than 2.6.19
means ohci1394 is non-functional (no 1394 hosts are detected) and the
module cannot be removed.

I have narrowed it down to 2.6.19 works, 2.6.20-rc1 doesn't.  Lots of detail at:

http://bugzilla.kernel.org/show_bug.cgi?id=7942

-- 
Robert Crocombe
