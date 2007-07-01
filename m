Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbXGAEiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbXGAEiP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 00:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbXGAEiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 00:38:05 -0400
Received: from web39512.mail.mud.yahoo.com ([209.191.106.96]:32439 "HELO
	web39512.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750836AbXGAEiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 00:38:04 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jul 2007 00:38:04 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=xvyBx2+g3excMj+M3otE8ZvmqFRdDQLAqBYQTVsxB/m/8V8qJJtPMQwnuzLGbYRQhVEKaf3MwnXUwWFthYZM1wUcdFmsq3k3Rspqo8l+gArlwsoKfCw21mrIDVOhNijSXg+ltFTXB8AhuNthNn2f9BsdgAeZn6+J3MkWOYaWzcU=;
X-YMail-OSG: ViuzuV4VM1lmmvWGXlHP8a5b98uG8HxktT1vUoKT4n8.GTPPg.128OMVP9KV8UK6_yNvsEElMma3t68afYQgpssOttT6vhX_DadVnYlheHPf4YuLdrhy6W9Jy3N3vQ--
Date: Sat, 30 Jun 2007 21:30:40 -0700 (PDT)
From: jim miro <daliroot@yahoo.com>
Subject: kvm_amd: Unknown symbol signal_pending - where should I be looking?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <95403.37043.qm@web39512.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to get Kvm running on Debian with a custom
 2.6.22-rc5 amd dual core kernel.

To prepare I do:

/sbin/modprobe kvm-amd
FATAL: Error inserting kvm_amd
(/lib/modules/2.6.22-rc5/extra/kvm-amd.ko): Unknown
symbol in module, or unknown parameter (see dmesg)

dmesg returns:
kvm_amd: Unknown symbol signal_pending

lsmod shows:
kvm                    56996  0

ls /lib/modules/2.6.22-rc5/kernel/drivers/kvm
kvm-amd.ko  kvm.ko

a google search on:
kvm_amd: Unknown symbol signal_pending
returns nothing

Any clues where to look?





      ____________________________________________________________________________________
Fussy? Opinionated? Impossible to please? Perfect.  Join Yahoo!'s user panel and lay it on us. http://surveylink.yahoo.com/gmrs/yahoo_panel_invite.asp?a=7 

