Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbXHERYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbXHERYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 13:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752236AbXHERYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 13:24:12 -0400
Received: from web33710.mail.mud.yahoo.com ([68.142.201.207]:33224 "HELO
	web33710.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752074AbXHERYM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 13:24:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=MmKPbygU8IjwnIv5ATAPtZ3NT44yISEop/XCaS9EMe61LyPNnBMMNYsTHkja6VmgClEbpB9IjqYsdNZ2w/nUHid9qBJKs086lwQc2CW0Y0WvoFwRUt0msd4T5qqrb3GaZTciiAXFjFFmBZiTeO6nvcQU4a01xi0/4UIWhmaI8IQ=;
X-YMail-OSG: cXmZOv4VM1nY8ysyzO_xJ4eKNBOvbC7TIe3ND4vv_Dc9ul0YkxvTD46N7KNeWhNvSDxbC3FLO_QH_SzgeTQ2AominDTmXo9ymz3Vc8_NImGf1MT5hcU-
X-Mailer: YahooMailRC/651.41 YahooMailWebService/0.7.119
Date: Sun, 5 Aug 2007 10:24:08 -0700 (PDT)
From: Adnan Khaleel <akhaleel2001@yahoo.com>
Subject: Re: Page Cache question
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-ID: <970535.60395.qm@web33710.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

So would it be possible to me to disable it for just a particular user space process?

Adnan


> I'm looking for a way to disable the page cache for an

> experimental NUMA system running the 2.6.17 kernel. I would prefer to

> only disable the page cache for my process and still have it be enabled

> by the rest of the system. Is there an easy way of doing this?

> Alternatively, I would be fine disabling the Page Cache altogether as well.



All user memory is in the page cache. Without it you could only run kernel

modules.



-Andi

-





       
____________________________________________________________________________________
Building a website is a piece of cake. Yahoo! Small Business gives you all the tools to get online.
http://smallbusiness.yahoo.com/webhosting 
