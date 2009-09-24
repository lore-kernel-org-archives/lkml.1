Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbZIXIEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbZIXIEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZIXIEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:04:48 -0400
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:38436 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751387AbZIXIEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:04:46 -0400
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2009 04:04:46 EDT
Message-ID: <4ABB25A4.3050901@yoshifuji.org>
Date: Thu, 24 Sep 2009 16:54:12 +0900
From: =?UTF-8?B?IllPU0hJRlVKSSBIaWRlYWtpICjlkInol6Qg6Iux5piOKSI=?= 
	<hideaki@yoshifuji.org>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: KV Pavuram <kvpavuram@yahoo.co.in>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Socket vs File descriptor
References: <179773.9311.qm@web8404.mail.in.yahoo.com>
In-Reply-To: <179773.9311.qm@web8404.mail.in.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KV Pavuram wrote:
> Is there any  ioctl call to determine if a given descriptor is a file descriptor or a socket descriptor.
> 
> Similarly, is there a way to find out a socket descriptor type ie.e if it is SOCK_STREAM, or SOCK_DGRAM type.

Maybe "lsof" command is your friend.

Or, depending on your purpose, you can use
getsockopt(), listen() etc. to get error
(e.g. ENOTSOCK) to test the type.

--yoshfuji
