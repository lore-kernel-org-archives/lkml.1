Return-Path: <linux-kernel-owner+w=401wt.eu-S1760480AbXIZS6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760480AbXIZS6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbXIZS56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:57:58 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55987 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629AbXIZS56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:57:58 -0400
Date: Wed, 26 Sep 2007 12:57:57 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>
Subject: dmapool
Message-ID: <20070926185757.GM3899@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I have a series of patches to dmapool that I'd like opinions on.  I
don't have any performance numbers yet, but some of the patches are a
good idea, with or without performance numbers.

One of the problems with dmapool is that it doesn't have a maintainer
listed.  I've spent enough time looking at it over the past couple of
weeks that I think I'd be comfortable in that role, so unless someone
objects, I'll submit a patch to MAINTAINERS to add myself.

I shan't post the first two patches.  The first simply Lindents the code
and the second moves it to mm/ (a better fit than drivers/base, IMO).

Four patches to follow.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
