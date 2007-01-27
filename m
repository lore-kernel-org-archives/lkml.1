Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312AbXA0SHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbXA0SHb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 13:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXA0SHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 13:07:31 -0500
Received: from web52503.mail.yahoo.com ([206.190.48.186]:48411 "HELO
	web52503.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752312AbXA0SHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 13:07:30 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Jan 2007 13:07:30 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=gQd36xsO5B0B8Lwh1bx3PuxfJ/PElgoMJzfmomD1OOY7oqjbDrahadqDfr2b2ow/NLliRKrsPtuq/yhefr1gSNoS4FJbaWEk+GwmAOo7ErvoPHtkIxPMmfhDuxcfP1FZ1SkkekBZQmDudh/s0oOyt0ZoURiHTXGqCd3aYz2B7aQ=;
X-YMail-OSG: bl0KGCMVM1mwNe7vsXuXKUmTYdIjWguiLad0KdeiiVTJUFwDfsgWDJOK4FF.kFfsqohsf45wUi6sSI8wTbsxNDKXZOKTQqkxhVBCxLRbB.ulUZlx09rpWC142ejE6zY19QyqxxH1A9ygQMOPArlKpeLJp5.hQhc28abrt4zcnghPzOWvLbRbIjp8Y9pa
Date: Sat, 27 Jan 2007 10:00:48 -0800 (PST)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Raid 10 question/problem [ot]
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <478459.76045.qm@web52503.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm a little stumped trying to set up raid 10. I set
it up and it worked but after a reboot it forgets my
raid setup.

Created 2 raid 1 arrays in md0 and md1 and that works
and survives a reboot.

However - I created a raid 0 on /dev/md2 made up of
/dev/md0 and /dev/md1 and it worked but it forgets it
after I reboot. The device /dev/md2 fails to survive a
reboot.

Created the /etc/mdadm.conf file but that doesn't seem
to have made a difference.

What am I missing? Thanks in advance.




 
____________________________________________________________________________________
Don't pick lemons.
See all the new 2007 cars at Yahoo! Autos.
http://autos.yahoo.com/new_cars.html 
