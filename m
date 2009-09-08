Return-Path: <linux-kernel-owner+w=401wt.eu-S1750778AbZIHO1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750778AbZIHO1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbZIHO1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:27:40 -0400
Received: from netsys.kaist.ac.kr ([143.248.239.50]:57718 "EHLO
	netsys.kaist.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbZIHO1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:27:40 -0400
From: "Junhee Lee" <junhee@netsys.kaist.ac.kr>
To: <linux-kernel@vger.kernel.org>
Subject: microsecond event scheduling in an application
Date: Tue, 8 Sep 2009 23:27:40 +0900
Message-ID: <015f01ca3090$85e8a280$91b9e780$@kaist.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcowkIPBzI9zOqJORxyOWEwDWhKexA==
Content-Language: ko
x-cr-hashedpuzzle: AkbU BHZv CaaR CoVn DYRY EVHj F9vi GNzK G/qr HQIX H6Ln IAlq Jk+o LBBw LeYT Le7T;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{0290781C-5ACA-4336-A175-D1C12D99C824};agB1AG4AaABlAGUAQABuAGUAdABzAHkAcwAuAGsAYQBpAHMAdAAuAGEAYwAuAGsAcgA=;Tue, 08 Sep 2009 14:27:37 GMT;bQBpAGMAcgBvAHMAZQBjAG8AbgBkACAAZQB2AGUAbgB0ACAAcwBjAGgAZQBkAHUAbABpAG4AZwAgAGkAbgAgAGEAbgAgAGEAcABwAGwAaQBjAGEAdABpAG8AbgA=
x-cr-puzzleid: {0290781C-5ACA-4336-A175-D1C12D99C824}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am working on event scheduler which handles events in microsecond level.
Actual this program is a network emulator using simulation codes.
I'd like to expect that network emulator is working as simulation behaviors.
Thus high resolution timer interrupt is required.
But high resolution timer interrupt derived by high tick frequency (jiffies
clock) must effect the system performance. 
Are there any comments or ways to support microsecond event scheduling
without performance degradation?

Regards 


