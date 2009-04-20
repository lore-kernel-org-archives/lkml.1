Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZDTRub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZDTRub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 13:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZDTRuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 13:50:22 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:62045 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZDTRuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 13:50:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=r/TTDI0BiHwJ8tk8RZtQjXaDCatHaoN4SCtB1Psuj8h49Jx6RRNv4dz764k1QmyCSW
         WZyoFtx1AjwBiQ9M8HKOJDVB3vA/KFCHiJvI2Sim2Y/iWcoBc8sziEXRpTmhNiyXQSgJ
         9Oz8DHLToCU6YkegEFldiSDfXbjSZSZJ/S2+8=
MIME-Version: 1.0
Date: Mon, 20 Apr 2009 19:50:20 +0200
Message-ID: <1ef444010904201050g72651387se3feca3fbd68ce30@mail.gmail.com>
Subject: bond interface arp, vlan and trunk / network question
From: stefan novak <lms.brubaker@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

I've got a Problem with my bladecenter and bond interfaces.
My Server has 2 interface, each on a seperate switch. Each
serverinterface is connected via a trunk to one of the switches.
Each switch has a trunk to stacked-backbone switch.

nic1 --trunk--> bladesw1 --trunk--> backbone switch
nic2 --trunk--> bladesw2 --trunk--> backbone switch

So far vlan and trunking works as expected. But if one trunk
connection from a bladeswitch to the backbone switch is down the
mii-tool cant recognize this.
I tried to use an arp target on the backbone switch to check the
connection state.

Now i'm running into problems. :(
My bladesw1 is configured with a trunk and a private vlan id of 600.
On the backbone switch is a server in the vlan 600 connected, but i
can't get an arp request.

What can be the problem, or is it possible to add a vlan tag on the arp check?

thx for your help and sorry for my bad english...

Stefan
