Return-Path: <linux-kernel-owner+w=401wt.eu-S1762059AbXGVMp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059AbXGVMp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 08:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760713AbXGVMpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 08:45:09 -0400
Received: from web57707.mail.re3.yahoo.com ([68.142.236.70]:37416 "HELO
	web57707.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759632AbXGVMpH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 08:45:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ES6ISmKlhSjNfym6jtvwhgDiZjnYF+z3koCsytS4dqYX7APWu0DggC9zbH6cxsRMSbI1GFbszOUai2z82XXAeGQnzt+CgCiLRybzstKKk7CMxSNjgTnAK/+i+eaQCUEvxJr+SEkaGD5pro6Vbg8GhGCq95K+YKSq/zWFzEuUVuk=;
X-YMail-OSG: H7CHZNUVM1n9MIRlBxbZBBrdqwZXjuRUnOQLC0jRSEOsaT6U46jRVcylS9gWYdcqNEoxx1qS0eg9sy4f5KfLNIsIEpC_ARgz_0XnXyxU5xl1n8GuVI3PI7Tp3_ktS7kPgiwaeUHKnS6Q9Yw-
X-Mailer: YahooMailRC/651.41 YahooMailWebService/0.7.119
Date: Sun, 22 Jul 2007 05:45:06 -0700 (PDT)
From: Jacob A <jacoba51-tmp@yahoo.com>
Subject: Re: 2.4 Q: list of open files per inode?
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-ID: <333685.87286.qm@web57707.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, yes, this was my intention, to keep the state in filp->private_data.
But then at a timer routine I wanted to go over all the filps associated with the device
and check/modify the state. That's why I needed the open files list.
-Jacob

----- Original Message ----
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jacob A <jacoba51-tmp@yahoo.com>
Cc: Al Viro <viro@ftp.linux.org.uk>; linux-kernel@vger.kernel.org
Sent: Sunday, July 22, 2007 3:28:30 PM
Subject: Re: 2.4 Q: list of open files per inode?


On Jul 22 2007 05:26, Jacob A wrote:

>I want to keep an internal state per each registration instance, and I opted
>to use open() as the registration mechanism.

So why not just store it in filp->private_data?



    Jan
-- 



>

    Jan
-- 



