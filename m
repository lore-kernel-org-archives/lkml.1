Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbZKJRov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbZKJRov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbZKJRov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:44:51 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:63325 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353AbZKJRou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:44:50 -0500
Message-ID: <4AF9A63B.6010101@nortel.com>
Date: Tue, 10 Nov 2009 11:43:23 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: netdev@vger.kernel.org, Linux kernel <linux-kernel@vger.kernel.org>
Subject: sunrpc port allocation and IANA reserved list
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2009 17:44:53.0528 (UTC) FILETIME=[8275A980:01CA622D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


By default sunrpc ports are allocated at random in the range 665-1023U.
 However, there are many ports within this range which have been
reserved by the IANA (and others like port 921 which are not formally
reserved but are "well-known").

Given that a userspace application can be stopped and restarted at any
time, and a sunrpc registration can happen at any time, what is the
expected mechanism to prevent the kernel from allocating a port for use
by sunrpc that reserved or well-known?

Apparently Redhat and Debian have distro-specific ways of dealing with
this, but is there a standard solution?  Should there be?

The current setup seems suboptimal.

Chris
