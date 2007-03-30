Return-Path: <linux-kernel-owner+w=401wt.eu-S1945925AbXC3DwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945925AbXC3DwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 23:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945926AbXC3DwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 23:52:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:63836 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945925AbXC3DwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 23:52:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=UU7MoAsazkMgwv+DmodXY7SJ9kKPXBZRVbHePr9At4KeGZd2aF4dmnwwlrW9BA5qiFIhns8/0mvAIZv0RIcWXzobXqqikjnf5AzBkVDzrgZKPMeDS/FG496M5GQ6rVCMLH/fg9OsObH8ttmOumnTj2xqDfNxGCNOGiHzBMkA3tc=
Message-ID: <6d6a94c50703292052p2181cc89l2e217cd05ed36221@mail.gmail.com>
Date: Fri, 30 Mar 2007 11:52:20 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: rmk@arm.linux.org.uk, alan@lxorguk.ukuu.org.uk
Subject: [Quick question] serial core issue
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When register serial driver as a console, the driver function

my_remove()
my_shutdown()

seems be never called.

So the driver can't reclaim resource when the command "reboot" is issued.

Is it intended?

-Aubrey
