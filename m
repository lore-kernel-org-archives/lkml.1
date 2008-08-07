Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbYHGOsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbYHGOsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 10:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbYHGOsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 10:48:39 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:22747 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYHGOsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 10:48:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=awN+UbuZieZzh3XHb413z/6AXGsfIkrAm+7J16+uqKIWdfC7wY4JRxr20/4KU5QIYm
         n0WXxl67x0I9A2qy0V4HfYSp6H4kzQrUWWJ2ucJsQf9SaB1FFjxVRjanV0afeEsTnVGe
         yu20OPnqG3wJmTg6J5ptUTuvB4FO4jPpi018s=
Message-ID: <efeafa350808070748t652a77cm9bf28aad851aa791@mail.gmail.com>
Date: Thu, 7 Aug 2008 16:48:37 +0200
From: Lazy <lazy404@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: SKB BUG: Invalid truesize (412) len=28, ipsec related ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vanilla 2.6.25.13, working as a router, 4 interfaces about 100MBit/s traffic
using e1000 and tg3 ethernet drivers

it's a production machine so I basicly can't touch it now, I think
it's triggerd by ipsec tunnel because
before rolling this machine on production it was stress tested
(without the tunnel) to tune the firewall,
and there ware no BUG()'s triggerd.

Aug  7 07:16:49 cisco-ng kernel: SKB BUG: Invalid truesize (412)
len=286, sizeof(sk_buff)=156
Aug  7 07:16:51 cisco-ng kernel: SKB BUG: Invalid truesize (284)
len=142, sizeof(sk_buff)=156
Aug  7 07:16:51 cisco-ng kernel: SKB BUG: Invalid truesize (284)
len=142, sizeof(sk_buff)=156
Aug  7 07:16:54 cisco-ng kernel: SKB BUG: Invalid truesize (284)
len=134, sizeof(sk_buff)=156
Aug  7 07:16:55 cisco-ng kernel: SKB BUG: Invalid truesize (284)
len=134, sizeof(sk_buff)=156
Aug  7 07:16:59 cisco-ng kernel: SKB BUG: Invalid truesize (284)
len=142, sizeof(sk_buff)=156
Aug  7 07:16:59 cisco-ng kernel: SKB BUG: Invalid truesize (284)
len=142, sizeof(sk_buff)=156

tunnel is created by setkey
add 10.0.5.2 10.0.5.1 esp 0xxxx -m tunnel -E 3des-cbc ...

Tomorrow i will try to trigger it in a test environment, any pointers
how to get more info out of it?
I found this http://lists.openwall.net/netdev/2008/05/06/61 will it be ok ?

-- 
Michal Grzedzicki
