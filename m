Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbYKDQfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbYKDQfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYKDQe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:34:57 -0500
Received: from co203.xi-lite.net ([149.6.83.203]:46407 "EHLO
	toronto.xi-lite.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754111AbYKDQe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:34:57 -0500
X-Greylist: delayed 1702 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2008 11:34:56 EST
Message-ID: <49107304.2060006@parrot.com>
Date: Tue, 04 Nov 2008 17:06:28 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Linux Arm Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: arm checkstack
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Nov 2008 16:07:21.0793 (UTC) FILETIME=[6B4C8310:01C93E97]
X-AV-Checked: No Virus Found
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wonder why the arm version of checkstack only catch stack size >= 300
and < 10000 [1].
Why doesn't it use ".*sub.*sp, sp, #([0-9]{1,8})" to catch all stack usage ?


Matthieu



[1]
$re = qr/.*sub.*sp, sp, #(([0-9]{2}|[3-9])[0-9]{2})/o;
