Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbZDYXGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbZDYXGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 19:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZDYXGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 19:06:47 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:52725 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752852AbZDYXGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 19:06:46 -0400
Message-ID: <49F39786.6020303@pardus.org.tr>
Date: Sun, 26 Apr 2009 02:06:46 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: The current status of info, err and warn macros in kernel
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that I can't compile some out-of-tree modules like lirc,
lmpcm_usb on my 2.6.30_rc* source tree.
The compiler aborts saying "implicit declaration of function 'info'". I
googled and found the following thread
in linux-next mailing list:

http://markmail.org/message/64hm5ytumcifd3iw

I don't think that those macros are completely removed because it seems
that they're still heavily in use
after grepping on current linus-2.6 tree.

So, is it possible that there's a Kconfig option which makes the
compilation fail on those macros?
Why am I not able to compile those modules? Am I missing something?

Thanks,

Ozan Caglayan
http://www.pardus.org.tr/eng
