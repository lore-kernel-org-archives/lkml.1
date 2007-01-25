Return-Path: <linux-kernel-owner+w=401wt.eu-S965713AbXAYJQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965713AbXAYJQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 04:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965722AbXAYJQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 04:16:07 -0500
Received: from web52903.mail.yahoo.com ([206.190.49.13]:39727 "HELO
	web52903.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965713AbXAYJQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 04:16:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=08vfs4zSc9TsPk1+8ggyfEg5JbaMsJN5V71N1GTaX2sbyDI/IRl76/VX94kfzFOSvfND4kqEuLU+XKi9f+jaQZZo95ju4WmhxXlHPQYZRJQHdYWVOWOsVCA7cBNCLztPStieom59WQkoJ/CkpqrwD24q9Edxz49UohUb70xVGzg=;
X-YMail-OSG: 2zhql0IVM1lyExyPdUnrKhXE3s13lvLXIKl7JKFmB0d7ZbSNcoClJH3NMYo4QSHgL3nRFap_h1VkdFwoANXN5_FEdNbHS9igF23Cj23ko6lR9goge0xWXtQhSrMGCq8JeNJX8HJm5cQsRuE-
Date: Thu, 25 Jan 2007 09:16:04 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 2.6.18-stable release plans?
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20070125010020.GB26654@deepthought>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <486377.64357.qm@web52903.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Ken Moffat <zarniwhoop@ntlworld.com> wrote:
> At the moment, you have a problem that nobody recognises.  If you're not
> willing to test if the problem happens repeatably, (you appear to
> have had one failure and immediately reverted to an old kernel), who
> do you think will be able to fix it?

This bug seems to be in the kernel's "memory management", and the last memory-related bug I had
(caused by a bad DIMM on another machine) caused creeping filesystem corruption. However, this
machine is my main desktop, and so I am keen to keep the filesystems intact. So yes, that involves
not running a kernel that has shown itself to be unreliable. 

I was hoping that someone with a deeper knowledge of the differences between 2.6.18 and 2.6.19
would have an idea of what might have triggered this problem, and yes, I was also thinking that
some more people would trip over it and help debug it.

But anyway - can someone please tell me what "Eeek! page_mapcount(page) went negative! (-1)" is
*really* saying/implying? Because I am currently translating this as "I WANT TO EAT YOUR
FILESYSTEMS".

Cheers,
Chris



	
	
		
___________________________________________________________ 
New Yahoo! Mail is the ultimate force in competitive emailing. Find out more at the Yahoo! Mail Championships. Plus: play games and win prizes. 
http://uk.rd.yahoo.com/evt=44106/*http://mail.yahoo.net/uk 
