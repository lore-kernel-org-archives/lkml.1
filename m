Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbYIQEwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbYIQEwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 00:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYIQEwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 00:52:32 -0400
Received: from cnmailgate04.alcatel-sbell.com.cn ([211.144.215.47]:40285 "EHLO
	cnshjsmin03.cn.alcatel-lucent.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751313AbYIQEwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 00:52:31 -0400
X-Greylist: delayed 2704 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Sep 2008 00:52:31 EDT
X-AuditID: ac189297-aa780bb000000fe5-f0-48d08a4383ae
Message-ID: <48D07C2F.2040500@alcatel-lucent.com>
Date: Wed, 17 Sep 2008 11:40:31 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: how to change priority of telnet session
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2008 03:40:30.0977 (UTC) FILETIME=[22249F10:01C91877]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I'm using telnetd which was started by xinetd. The current default 
priority of telnetd isn't high enough,
so I want to increase it by conf files. Do you know how to increase 
telnet or telnetd's priority through
changing conf files?

root@(none):/etc/xinetd.d# cat telnet
# default: on
# description: The telnet server serves telnet sessions; it uses \
#       unencrypted username/password pairs for authentication.
service telnet
{
        flags           = REUSE
        socket_type     = stream       
        wait            = no
        user            = root
        server          = /usr/sbin/in.telnetd
        log_on_failure  += USERID
}

Thanks,
Gavin
