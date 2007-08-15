Return-Path: <linux-kernel-owner+w=401wt.eu-S934263AbXHOSFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934263AbXHOSFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 14:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760034AbXHOSF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 14:05:26 -0400
Received: from web52508.mail.re2.yahoo.com ([206.190.48.191]:22339 "HELO
	web52508.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758896AbXHOSFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 14:05:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=nKl1PihDxshPHtHNXYrROkFyo+NnuPdrhD98G0ACaQacfeRdoiLF8+aKvkcLXeNXVduMsyC2JdkFHhCPIMf2JWHu/DNzCS7LJ8JxKvtireKvkBKPBIkfYEMMi6OZZeI8lfGRaMQefeY3xviLq1ikjjx0B6O1Xyy+VBhjQLdcljw=;
X-YMail-OSG: SyUggVgVM1kFLXAFEAWCKNiB2PUFZdeZJwg.FaH0r56LO6hu7AGM3eebLGudJHNTfgWld5d0WoBBkLgm9T9WEb41Yiwp2.yUgQlx
Date: Wed, 15 Aug 2007 11:05:23 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Kyle Moffett <mrmacman_g4@mac.com>, Phillip Susi <psusi@cfl.rr.com>
Cc: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
In-Reply-To: <DE34FF90-3143-4978-BBC5-3CF74B8C3C07@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <824590.88264.qm@web52508.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle,

In this new system setfacl, chmod, chown, and chgrp
all go away except inside of an emulation layer. File
and directories no longer have permissions. People
have permission to naming patterns. So if you put a
file into a tree or move a tree then those who have
permissions to the tree have access to the files. 

It eliminates the step of having to apply permission
after moving files into a tree. You don't have to
change file permissions because files no longer have
permissions.


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      ____________________________________________________________________________________
Shape Yahoo! in your own image.  Join our Network Research Panel today!   http://surveylink.yahoo.com/gmrs/yahoo_panel_invite.asp?a=7 


