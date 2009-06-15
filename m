Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbZFOWkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbZFOWkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 18:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZFOWkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 18:40:10 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:43766 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbZFOWkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 18:40:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=jWie1e728Way8YKRj80qI0xDTJQFCBBQWb2oyJDsTKHNn4ef93qYMNupvKSdQZxBm6
         oJ79BGytduXJrcnydGUmtEJFp4XJ4zZujBEflyPrekoLXFmbHh+BlIlx2BvfiGLoQEcQ
         yKhy+xgBZUwWbawKIqVH4Y9xr3zQGDEmYG3fI=
MIME-Version: 1.0
Date: Mon, 15 Jun 2009 18:40:09 -0400
Message-ID: <4a347610906151540m3b05ec0eob15f5a51fd974@mail.gmail.com>
Subject: bonding: when bond0e goes down, local route still stays up
From: Mahesh Kelkar <maheshkelkar@gmail.com>
To: linux-net <linux-net@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bonding configured with miimon=100, mode=balance-xor
bond0 is assigned ip address 10.10.10.1/24 (that adds the local route
10.10.10.0/24 dev bond0)
bond0 enslaves the eth0

if eth0 is administratily disabled, then bond0 senses the carrier down
and logs the following events:

<6>bonding: bond0: link status definitely down for interface eth0, disabling it
<6>bonding: bond0: now running without any active interface !

But, the local route i.e. 10.10.10.0/24 dev bond0 still stays around;
shouldn't it go away? I mean thats the common behavior with all the
other devices.

Thanks
Mahesh
