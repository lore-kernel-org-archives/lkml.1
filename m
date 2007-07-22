Return-Path: <linux-kernel-owner+w=401wt.eu-S1764597AbXGVM02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764597AbXGVM02 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 08:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758947AbXGVM0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 08:26:20 -0400
Received: from web57701.mail.re3.yahoo.com ([68.142.236.53]:28559 "HELO
	web57701.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757966AbXGVM0U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 08:26:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=dK0thGACw4CSfdqK8UHWlmJ+cfvGsbVsrjNqu9aZkVYXMr3MF00GURJW5C6lQGflWTqzAXRyNlinkrLVnL2D8NNl13hCUg3PWog1TskqqmNalhh8NDiUClLyvKX6M3bm6vqHIzXEY51J3k/d45vD+48htI3CLSeDjotBLgd7YEM=;
X-YMail-OSG: LLI4tnQVM1lrnz5TpjaQz9LTKTSX3VmHn_Q1.iau6VHytcAgCxhFraPK0UkUO8vzYA--
X-Mailer: YahooMailRC/651.41 YahooMailWebService/0.7.119
Date: Sun, 22 Jul 2007 05:26:19 -0700 (PDT)
From: Jacob A <jacoba51-tmp@yahoo.com>
Subject: Re: 2.4 Q: list of open files per inode?
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-ID: <35493.81201.qm@web57701.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I want to keep an internal state per each registration instance, and I opted to use open() as the registration mechanism.
-Jacob

----- Original Message ----
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jacob A <jacoba51-tmp@yahoo.com>
Cc: Al Viro <viro@ftp.linux.org.uk>; linux-kernel@vger.kernel.org
Sent: Sunday, July 22, 2007 2:58:18 PM
Subject: Re: 2.4 Q: list of open files per inode?


On Jul 22 2007 04:39, Jacob A wrote:

>I'm using the open/close call as a way for processes to
>register/unregister with a watchdog driver that I'm writing. I
>thought that I can save the housekeeping within the driver, but it
>looks like It would be easier just to maintain my own list and be
>done with it.

Sounds a bit wrong. _What_ exactly do you want to keep?


    Jan
-- 



