Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbYH3HSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbYH3HSI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 03:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbYH3HR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 03:17:56 -0400
Received: from n6.bullet.mail.ac4.yahoo.com ([76.13.13.234]:46781 "HELO
	n6.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751061AbYH3HR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 03:17:56 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Aug 2008 03:17:56 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 504605.63708.bm@omp108.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=bGuZH3HCVy4AQSJAJ07xLreWZYncu1or14necEYZu8fNniYAg4Uq4rRO64CRX+1xEFIoSlfu55w5y74SldVrn4o7qIGYqEyv+wr/uyx5PgpcIXeA3+9IkEnJEIJTTN0dNEQQjPCRAWGnls4iNi2axc+4Zv9MWsGvjlJDEisq60E=;
X-YMail-OSG: MPvkAg4VM1n88ndesD4LUDrWMJQouzlrimkZnvXlQPirp2m1w8uk_Towv7FMSEnEz_ltMupdOlMdJVX3JOVesUk9B40SlfD1RolaLdp87A--
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Sat, 30 Aug 2008 00:12:12 -0700 (PDT)
From: Firstname Lastname <skb632@yahoo.com>
Subject: targets of function pointer invocations
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <269784.46170.qm@web59506.mail.ac4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The lines 522-523 in function do_acct_process in file kernel/acct.c in version 2.6.26.3 are:

 file->f_op->write(file, (char *)&ac,sizeof(acct_t), &file->f_pos);

What are the full set of targets of this function pointer invocation and how can one be sure, by examining the code, that this is in fact the complete set?

Thanks.

SKB



      

