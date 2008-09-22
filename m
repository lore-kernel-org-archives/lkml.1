Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbYIVV2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbYIVV2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYIVV2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:28:35 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:58341 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbYIVV2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:28:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ChxW5/uU4ziJoj621UC4phLdQKeuIyUu7tjwrlsjHEpXp7F+rWdHQGBS+QG/oaX2ws
         eZPuOftEjXhOBYJu/8kNQPhVhZ+XhR/ZKQzCjx5m734oh1TgLhjaq0WPjabBGLiKw+ls
         f5XBSTGNqAwak1/UbZrLTJYo/iaAAJC/kaAHw=
Message-ID: <4a347610809221428g3f5d65d2n41fd6d72864a4938@mail.gmail.com>
Date: Mon, 22 Sep 2008 17:28:33 -0400
From: "Mahesh Kelkar" <maheshkelkar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Sending ARP requests to the peer over PF_PACKET socket
In-Reply-To: <4a347610809221422y74ec165fj1aa2819ca27b6801@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4a347610809221422y74ec165fj1aa2819ca27b6801@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IP utility "arping" uses PF_PACKET socket to send the arp_request to
the peer. When peer responds with arp_reply, one copy is sent to the
PF_PACKET socket and other to the linux kernel. As a result, linux
kernel creates the new ARP entry.

In this case, kernel doesn't know about the arp_request, hence it
should treat the arp_reply as unsolicited. Linux Kernel (v2.6.21) by
default does not accept unsolicited ARP replies, then how what makes
kernel accept the ARP reply?

Is kernel snooping in the packet with arp_request going out over the
PF_PACKET socket?

Any response is appreciated.

Thanks
Mahesh
