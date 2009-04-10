Return-Path: <linux-kernel-owner+w=401wt.eu-S935681AbZDJDCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935681AbZDJDCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 23:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764901AbZDJDB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 23:01:29 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:46479 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160AbZDJDB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 23:01:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18910.46709.707557.135033@stoffel.org>
Date: Thu, 9 Apr 2009 23:01:09 -0400
From: "John Stoffel" <john@stoffel.org>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: "John Stoffel" <john@stoffel.org>, Jarek Poplawski <jarkao2@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: usb_mon oops Re: tcpdump crashes 2.6.29.1 (and 2.6.29-rc5)
In-Reply-To: <20090408232344.afed8103.zaitcev@redhat.com>
References: <18906.49779.243047.207639@stoffel.org>
	<20090407120022.GA6519@ff.dom.local>
	<18907.28788.965069.573489@stoffel.org>
	<20090407130403.e0061a8d.zaitcev@redhat.com>
	<18908.42166.404232.721757@stoffel.org>
	<20090408232344.afed8103.zaitcev@redhat.com>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, I've confirmed that it's usbmon under 2.6.29.1 on x86_64 which causes
complete system lockups when doing 'tcpdump host ##.##.##.##'.  I
compiled usbmon as a module, started a tcpdump and couldn't get a
crash. 

Loaded the module with tcpdump still going, no problems.  Stop and
restart tcpdump, bang!  Instant hang.  I'm now building 2.6.28 to see
if that works properly or not.  I suspect I might have to go back
farther, but I'm not sure.

Any suggestions of a known good state I should start bisection from?

Thanks,
John
