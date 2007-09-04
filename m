Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595AbXIDMTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbXIDMTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 08:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbXIDMTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 08:19:31 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:28331 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbXIDMTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 08:19:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=owCEgB+ejf5ILjNjMuzxvh72b4fS8hljXXoaRFnuWvRsNmYyNAS8ddpGcp9BL+UDuJDW3Mi0PQ5Vs65nfmfIjSZp6Y+eM4yqz5GmbfNatOj9oIMjq868AQ/QDjxhhRhcz3uTYKwcxCz/hJs8D321qz5Hp/YYywXuQC7l9OjHqW0=
Message-ID: <228b46650709040519t417187c9ra5bbdd5e1b4a464d@mail.gmail.com>
Date: Tue, 4 Sep 2007 17:49:29 +0530
From: "rajneesh rana" <rana.rajneesh@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: making local traffic to pass through bridge
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hello all

I am writing two user level filter which interacts through each other
using TCP sockets.Now as traffic is local, it is passed through the
loopback interface. That is my design constraint.

I want to force the local traffic between particular interfaces to go
through bridge where i want to do some sort of NAT.To force the
traffic to bridge, i m opening up two tap devices and using
SO_BINDTODEVICE options to force the traffic to bypass loopback. But
connection is not getting established.

Is this design feasible.

Best Regards
rana
