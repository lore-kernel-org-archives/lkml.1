Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbYGYPUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbYGYPUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYGYPUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:20:11 -0400
Received: from n60.bullet.mail.sp1.yahoo.com ([98.136.44.40]:37345 "HELO
	n60.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750729AbYGYPUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:20:10 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 946038.24871.bm@omp403.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=I61TZoIUXA0EHxqu/+eD9r3rX4VYy4Cz1H5FEwSwQ+DZ17XTZE9uN1YWPRhN+6VdAXQrwxh/zsGX31yvY/iCMi3CqS7PFISwLHPgUi9qTe3AXF3fH2/N18AyFBLPlSpGnRWiuy5s/MloHWX6jJqX3NK7yITWY46K0h1XIp0L7PM=;
X-Mailer: YahooMailWebService/0.7.218
Date: Fri, 25 Jul 2008 08:20:09 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
Reply-To: free_beer_for_all@yahoo.com
Subject: WLAN regression before this morning
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <761713.15647.qm@web46115.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Servus,

Last successfully built and used kernel was 2.6.26-rc8, about
the start of 29.Jun UTC or so.

Present build of GIT 2.6.26 during the merge window, updated
just before 06h UTC, today, 25.Jul.

With today's kernel, I am not even able to associate with a
WLAN less than two metres away from my ZD1211rw type USB
adapter, to say nothing of more distant WLANs with which I
could authenticate with the earlier code without problems --
I don't even come near the associate stage.

The networks all show up as expected in `iwlist wlan1 scan'
with decent strengths; while all I get from dmesg is
[ 1016.829827] wlan1: authenticate with AP 00:1X:YZ:AB:23:45
[ 1017.032769] wlan1: authenticate with AP 00:1X:YZ:AB:23:45
[ 1017.234213] wlan1: authenticate with AP 00:1X:YZ:AB:23:45
[ 1017.435402] wlan1: authentication with AP 00:1X:YZ:AB:23:45 timed out


If I've hosed myself with a new .config option, I'll be kicking
meself where it hurts most.  Else, back to -rc8 to both send
this message and to regain 'net access to do other needed so-
called `work', so sorry I haven't narrowed this down further...

And I'll feel me a fool if the failure is because I went from
a different (BSD) OS into 2.6.26-merge, while going from that
into -rc8 I promptly associate as desired.


thanks
barry bouwsma


      

