Return-Path: <linux-kernel-owner+w=401wt.eu-S933732AbZLFLjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933732AbZLFLjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 06:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933698AbZLFLjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 06:39:43 -0500
Received: from web27006.mail.ukl.yahoo.com ([217.146.177.6]:46930 "HELO
	web27006.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933676AbZLFLjm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 06:39:42 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Dec 2009 06:39:42 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=5/mUNxfSgKEM+85qxlrxjyXb57sXq2P2uvlZZ4m4dumnxY9hYMRItIOqayRlxd3ydgAGbSjOrCDxpdCqyFHkNXBGifJwRG24teTdlfvkVJtVsC2z2E4c8fyAREJj4uIfEJ+nlfif/h9UHaJ2DqftdpQCF0vCE+k5gRSAxrltT1s=;
Message-ID: <371220.64690.qm@web27006.mail.ukl.yahoo.com>
X-YMail-OSG: 5ZHytQsVM1nQvSdr51XucxIY0Mu3av9giiWt.lArxSK.tnMtN1PCdbKXG1BwgKrTaTlJfaiaeqAs0W4m6eO926m6E3h7MCQszjO69XMq8R2Wyy5w.GILdd9DvdWr1l3owf7w.HEQtuse47hJp_Hzc5bBsk76MFwRlF2Q6a6M9tFvwlFMEYyMLKzKklpj8XO3kdQ_PSjC8g5_mnzU15r4Fh6fOkjg37FZ_1oicHR6YgJdt1fPWWIi25p77Kdq7HWOJ7MQ0cuz312N68QTvMRJMekbPoxG4F5PTi41stoEDmY-
X-Mailer: YahooMailClassic/9.0.19 YahooMailWebService/0.8.100.260964
Date: Sun, 6 Dec 2009 11:33:07 +0000 (GMT)
From: bifferos <bifferos@yahoo.co.uk>
Subject: Kexec failure on RDC (and possibly other early x86) platforms
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've updated the patch to allow Kexec to work on RDC platforms
here:
http://bifferboard.svn.sourceforge.net/viewvc/bifferboard/slack/kernel/2.6.32/0003-kexec-fix.patch

I'm curious as to how one can detect the presence of the CR4 
register in assembler, as I'm sure it's possible, but I've just 
#ifndefed out the offending instruction in this patch and it
seems to work with this change.

regards,
Biff.


      
