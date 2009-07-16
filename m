Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbZGPGRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbZGPGRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 02:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756280AbZGPGRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 02:17:19 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52203 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbZGPGRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 02:17:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:content-type:content-transfer-encoding:subject
         :mime-version:date:x-mailer;
        b=H6oq7rWh0AdhhF8pODFwWOnCzvO2Si3BlQbgraSJWQL6EpokYcTBaWXHuCSlE+xjT/
         9byfCoSwO9MDpRcXbI5S6o2OKmXnGjeHsrYweam7DQAsLTgBWSGOGOYREe7v+z8NsNMf
         IhVbq+pSTR1YTexsEd4/lNh2fKbCCmHyLzndo=
Message-Id: <88A69E70-10FB-414A-9542-EBC9E0768D23@gmail.com>
From: Patrick Rittiner <rittiner@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Subject: RAW ethernet in kernel space
Mime-Version: 1.0 (Apple Message framework v935.3)
Date: Thu, 16 Jul 2009 08:17:15 +0200
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi everyone,

I have a problem, I would like to open a ethernet socket and receive  
all data (RAW ethernet) on the ethernet interface on it. ( interface  
has to be in promisc mode ) In user space this is not a big problem,  
but how can I do it in kernel space? I mean, i can not use functions  
like ioctl() and socket(), right? so I think there is a sock_create().

so how can I write code like this for kernel space:

	memset(&ifInfo, 0x00, sizeof(ifInfo));
	strncpy(ifInfo.ifr_name, iface,  IFNAMSIZ);
	ioctl(sock, SIOCGIFFLAGS, &ifInfo);
	ifInfo.ifr_flags |= IFF_PROMISC;
	ioctl(sock, SIOCSIFFLAGS, &ifInfo);

thanks for your help
