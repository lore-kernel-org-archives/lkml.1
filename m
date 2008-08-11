Return-Path: <linux-kernel-owner+w=401wt.eu-S1751533AbYHKFOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbYHKFOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 01:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbYHKFOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 01:14:38 -0400
Received: from esbens.latnet.lv ([92.240.66.74]:42540 "EHLO esbens.latnet.lv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbYHKFOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 01:14:38 -0400
From: Aivils Stoss <aivils@latnet.lv>
To: linuxconsole-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: KEYBOARDS: Why /dev/hiddev* is disabled for keyboards
Date: Mon, 11 Aug 2008 06:14:31 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808110614.31887.aivils@latnet.lv>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All!

I work for project which will use 15 - 25 keyboards for children teaching.
Current version of software uses /dev/input/evdevXX interface, which
is allways crowded and reach maximum allowed 32 device files
very fast - 12 keyboards for ordinary laptop PC.

I take a look into /dev/hiddev* code, which have similar protocol
like evdev, but is disabled for keyboards.
WHY?
