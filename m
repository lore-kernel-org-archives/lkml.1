Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbYFQONp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbYFQONp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbYFQONi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:13:38 -0400
Received: from web8712.mail.in.yahoo.com ([203.84.221.133]:48024 "HELO
	web8712.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757535AbYFQONh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:13:37 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jun 2008 10:13:36 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=mcCngb9/49+Q19Vc7R8pU6v02TCbof6uCdNh+p4dOXZOrd/KpCwhpVG3Ly7xjB7oLPffAonV7mPpjOZyVWV9zNySO3O4jJdJbGDjm09HK8cti4v694WG0fACEPuY2H1M6eRAlSTA9nACJGm6fJ/snw0rI68RQ4HLQisgaJ0Pu8E=;
X-Mailer: YahooMailRC/975.45 YahooMailWebService/0.7.199
Date: Tue, 17 Jun 2008 19:36:53 +0530 (IST)
From: palani saravanan <busybeesaravanan0072003@yahoo.co.in>
Subject: Behavior of lseek() on a fd opened with 'RDONLY' flag, when seeking goes beyond file size.
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <535337.98001.qm@web8712.mail.in.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

   [Forgive me if this is not correct alias for this question. 
    (Behavior of lseek() on a fd opened with 'RDONLY' flag, when seeking goes beyond file size.)]

   In linux, I see that it just goes beyond the file size and returns the resulting offset.
   For example, 'rc = lseek(fd, 4L, SEEK_END);' on a file which has 5 byte contents,
   it returns rc as 9.
   I expect that it would return size of the file, i.e.) 5.

   I am not finding any posix documentation for this either.

   May I know the rational behind this behavior?  
   Does the file pointer internally really points to the new location.?

Thanks,
Saravanan



      Meet people who discuss and share your passions. Go to http://in.promos.yahoo.com/groups/bestofyahoo/
