Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbXHTBP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbXHTBP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 21:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbXHTBPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 21:15:49 -0400
Received: from web38903.mail.mud.yahoo.com ([209.191.125.109]:47995 "HELO
	web38903.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751017AbXHTBPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 21:15:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=zIhPOJeD0olg9UJbKDvMnH2NQEhwRJbfABdWJDOoqYnpIl71iuc0h30vci32o9reRK0EkaVXzmynTodt9rtQUTVhHIVdiU7ljypA5xKFuYNuvcVCzqzhVzTyhVUofcROjSLpmy/6tmooYC2wmVM5osW09yMeTMeQIraieQQNGWY=;
X-YMail-OSG: o8eD8_sVM1kuR.fugFT9a4eM5MHqkYzdvAsH0shfGZU_.RpbJ.VTYjzyX9L7W1GRcc4OoXgH1JYCGuaOg5NPBh9bKOslM5mtuNFkdH7qKFEL2xsnpW.6JdZJW9lGnA--
Date: Sun, 19 Aug 2007 18:15:47 -0700 (PDT)
From: Kevin E <kevin360@yahoo.com>
Subject: Re: Marvell 88E8056 gigabit ethernet controller
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <2456F7EB-000C-4B71-B002-64340DD17BA8@linuxmontreal.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <573746.86745.qm@web38903.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Someone wrote me with a solution to try and so far
it's working.  They suggested I try the driver up on
Marvell's website but to make sure I powered off the
machine completely and when it rebooted to not have
any of the regular kernel drivers for the Marvell
chipset to load.  They had found that letting the sky2
load and then unloading the module would mean the
vendor's driver wouldn't work.

So I got down the latest driver package they have
(10.0.5.3).  At first I couldn't get it compiled
against kernel 2.6.22.3 that I'm running, but I have
it compiled with the 2.6.21.5 kernel, which is what
the machine is running now.  And I'm happy to say that
it's working fine so far.  I've transfered about 4G
over the link and it's still working fine.

Since Marvell's driver seems to be working for the
88E8056 chipset and from what I've looked at the code
it's marked as GPL, could it be rolled into the kernel
for those of us that have 88E8056 chipsets that are
working to use? 



       
____________________________________________________________________________________
Moody friends. Drama queens. Your life? Nope! - their life, your story. Play Sims Stories at Yahoo! Games.
http://sims.yahoo.com/  
