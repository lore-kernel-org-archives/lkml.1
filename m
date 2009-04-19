Return-Path: <linux-kernel-owner+w=401wt.eu-S1760834AbZDSPj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834AbZDSPj1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 11:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbZDSPjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 11:39:18 -0400
Received: from qmta01.westchester.pa.mail.comcast.net ([76.96.62.16]:45951
	"EHLO QMTA01.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687AbZDSPjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 11:39:17 -0400
Message-ID: <49EB45A3.4040402@comcast.net>
Date: Sun, 19 Apr 2009 11:39:15 -0400
From: John Richard Moser <nigelenki@comcast.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Allocate on Flush in vfat?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would it be completely unpossible, in theory, to add allocate-on-flush 
to vfat?  I don't see a reason why, it's just a driver semantic and not 
a disk data structure semantic...

I'm looking at a USB stick copying gigs of data and thinking about this. 
I have doubts there's any real world advantage, although in the same 
theory you could backport AOF to ext3/2 or you couldn't.
