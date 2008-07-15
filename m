Return-Path: <linux-kernel-owner+w=401wt.eu-S1761431AbYGORAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761431AbYGORAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbYGORA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:00:28 -0400
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:58209 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755709AbYGORA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:00:27 -0400
Message-ID: <487CD7A7.2080800@jeffray.co.uk>
Date: Tue, 15 Jul 2008 18:00:23 +0100
From: Ian Jeffray <ian@jeffray.co.uk>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sendfile() broken with 2.6.26 + Apache 2 ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

I moved from kernel 2.6.25.4 to 2.6.26 yesterday and observed that
large files sent via Apache2 are partially corrupt.

This appears to be linked to sendfile() -- disabling the use of
sendfile in the apache config (EnableSendfile Off) allows it to
function as normal.

My system is a simple Core2Duo running Debian lenny/sid; nothing
special, and I have never observed problems like this before.

The problem feels certainly related to sendfile() since the data
reads correctly from disc in other programs, and via CIFS etc.

The corruption happens part-way in to the file... I've no exact
figure but it would seem like maybe 32KB -- I'm seeing broken
PNGs served from Apache, where the top few dozen lines decode
correctly, and the rest is garbage.

I've made basically no configuration changes between 2.6.25.4 and
2.6.26 and have explicitly tried both enabling and disabling the
new PAT support to no effect.

This is completely repeatable and reproducible.

Is anyone else seeing this broken behaviour?


Ian.

