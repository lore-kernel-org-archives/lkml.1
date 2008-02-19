Return-Path: <linux-kernel-owner+w=401wt.eu-S1759880AbYBSXkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880AbYBSXkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYBSXkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:40:32 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:41906 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbYBSXkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:40:31 -0500
Message-ID: <47BB68ED.4070105@xaerolimit.net>
Date: Tue, 19 Feb 2008 18:40:29 -0500
From: Chris Brennan <xaero@xaerolimit.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20080209)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: BT8x8 support
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have the following hardware installed in my Linux Box.

01:07.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)
01:07.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 11)

and the following devices installed in /dev

0 lrwxrwxrwx 1 root root       11 Feb 19 17:45 /dev/radio -> /dev/radio0
0 crw-rw-rw- 1 root video 81,  64 Feb 19 17:45 /dev/radio0
0 lrwxrwxrwx 1 root root        9 Feb 19 17:45 /dev/vbi -> /dev/vbi0
0 crw-rw-rw- 1 root video 81, 224 Feb 19 17:45 /dev/vbi0
0 lrwxrwxrwx 1 root root       11 Feb 19 17:45 /dev/video -> /dev/video0
0 lrwxrwxrwx 1 root root       10 Feb 19 11:59 /dev/video0 -> v4l/video0
0 lrwxrwxrwx 1 root root        9 Feb 19 17:45 /dev/vtx -> /dev/vtx0
0 crw-rw-rw- 1 root video 81, 192 Feb 19 17:45 /dev/vtx0

As far as I can tell, I have bt8x8 support compiled as modules. here
is a link to a copy of my .config. If someone can help me w/ making
sure I have the right stuff in and what I don't need out as far as
this card goes, I would be much appreciative.


