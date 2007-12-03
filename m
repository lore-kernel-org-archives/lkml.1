Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbXLCXGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbXLCXGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 18:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbXLCXGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 18:06:35 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:42486 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbXLCXGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 18:06:34 -0500
Message-ID: <47548BF4.3010907@nortel.com>
Date: Mon, 03 Dec 2007 17:06:28 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: solid state drive access and context switching
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Dec 2007 23:06:31.0306 (UTC) FILETIME=[245DE6A0:01C83601]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Over on comp.os.linux.development.system someone asked an interesting 
question, and I thought I'd mention it here.

Given a fast low-latency solid state drive, would it ever be beneficial 
to simply wait in the kernel for synchronous read/write calls to 
complete?  The idea is that you could avoid at least two task context 
switches, and if the data access can be completed at less cost than 
those context switches it could be an overall win.

Has anyone played with this concept?

Chris


