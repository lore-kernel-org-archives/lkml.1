Return-Path: <linux-kernel-owner+w=401wt.eu-S932303AbYEBJW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbYEBJW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758064AbYEBJWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:22:50 -0400
Received: from web30103.mail.mud.yahoo.com ([209.191.69.35]:35694 "HELO
	web30103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755126AbYEBJWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:22:50 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 May 2008 05:22:49 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=d6N/c92czhq65kYZzDgvljunxcMY9zzBp5foTq2/rVNI4L/zMZkzbsRFQh1+JKqc4Z3o+sTphocSpVD3NLkioDrWjc8suRY6FiTaprSlDEZMiCIhTaHo8zZAp66omowNp8R5KqMD0B48boguX85+6oePI/VHpb4dSXOlNakRfmU=;
X-YMail-OSG: 950ezT0VM1kQFLOC5kQu.kotMoXhoiziAfrlGQzTVB98o1pIyxWw4qGhRW85miZ.Thz3h2j6aSbn2NvSVa0NeZl637q6U9uhxXt4N4U7mnmN8LWS2F.h4OFe6w--
X-Mailer: YahooMailWebService/0.7.185
Date: Fri, 2 May 2008 02:16:07 -0700 (PDT)
From: Parav Pandit <paravpandit@yahoo.com>
Reply-To: paravpandit@yahoo.com
Subject: motive for sending Ethernet packets in soft-irq context
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <989596.46222.qm@web30103.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

What is the motive to send the ethernet packets to the NIC driver by invoking hard_xmit() in the soft-irq context?

What I understand is,
It is not done into the process context of send() system call beacause,
1. Calling it in soft-irq context eliminates any delays incurred by the process switching, lower task priorities etc.

Can't it be done by raising the process priority to highest until the NIC driver hand over the packet to the hardware?
This will avoid time incurred in process to soft-irq switching time.

Are there any other performance, security reasons?

Regards,
Parav Pandit



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
