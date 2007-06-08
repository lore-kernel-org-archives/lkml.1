Return-Path: <linux-kernel-owner+w=401wt.eu-S970165AbXFHQMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970165AbXFHQMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970186AbXFHQMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:12:07 -0400
Received: from terminus.zytor.com ([192.83.249.54]:46057 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970181AbXFHQME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:12:04 -0400
Message-ID: <46697FD0.9070006@zytor.com>
Date: Fri, 08 Jun 2007 09:12:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Should "cleanpatch" clean up stretches of space?
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Right now I have "cleanspace" and "cleanpatch" clean up spaces before
tabs, but it does not compress runs of spaces that aren't followed by a tab.

I could make it do that; I was being conservative when I wrote it and
opted for it not to do so, but I wanted to hear if people think it
should (and if so, what should a reasonable threshold be, in addition
for obviously crossing a tab line?  Two spaces?  Three?  Four?  Eight?)

	-hpa
