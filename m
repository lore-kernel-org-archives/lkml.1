Return-Path: <linux-kernel-owner+w=401wt.eu-S1761885AbYEYKYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761885AbYEYKYK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbYEYKXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:23:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41957 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbYEYKXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:23:38 -0400
Message-Id: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       Tyler Trafford <ttrafford@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
       Brice Goglin <brice@myri.com>, Andrew Gallatin <gallatin@myri.com>,
       Kirk Lapray <kirk_lapray@bigfoot.com>,
       Trent Piepho <xyzzy@speakeasy.org>,
       Patrick Boettcher <patrick.boettcher@desy.de>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Chris Pascoe <c.pascoe@itee.uq.edu.au>
Subject: [PATCHv2 00/28] Allow built-in firmware to be accessed by request_firmware()
Date: Sun, 25 May 2008 11:23:28 +0100
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second attempt, now in the git tree at 
git.infradead.org/users/dwmw2/firmware-2.6.git

At Alan's suggestion, start by making fw->data const so that we can 
avoid the extra vmalloc+copy when we find it built-in. Mostly 
straightforward, but could do with an extra pair of eyes and some 
testing for the cxusb, myri10ge, cx25840 and or51211 changes.

Also switch to using a .S file for the included firmware, which means we
can use .incbin instead of including the whole thing in hex form in a C 
file. And fix up the case where there were no built-in firmware 

-- 
dwmw2

