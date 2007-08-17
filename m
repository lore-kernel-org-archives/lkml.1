Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbXHQEYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbXHQEYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 00:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbXHQEY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 00:24:27 -0400
Received: from web52510.mail.re2.yahoo.com ([206.190.48.193]:29721 "HELO
	web52510.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752659AbXHQEY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 00:24:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=WDlnM908avM/kgbPn0YVAEqqbgj+iebpfQ+ho50y4TKcY00suGu7/jJewAuNUCeZIk0lt6L9fXsJNTf3sk1jWqbjtTe3t3aoy1dFjclJ1UeWME4DrmLSA7KAz2aMVX5mGXxKpUwO+fhr0XrQoC0gLe3PodreuenzJXTcztaedLE=;
X-YMail-OSG: pjCkrzwVM1kIcQL1zMZLEoMP66PyqeZKcIL0tQPTj0vPcmqgRFamSdjKx3rXUiyTBg--
Date: Thu, 16 Aug 2007 21:24:22 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Kyle Moffett <mrmacman_g4@mac.com>, Phillip Susi <psusi@cfl.rr.com>
Cc: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <5D526964-3F46-4B6D-A12A-437A7EF5E0D8@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <826926.60792.qm@web52510.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Several people have asked about how to mass move a
tree under my idea for a new kind of file system. I
have an idea. Suppose you have the file name as
follies.

/one/two/three/four/file1

Except the are a million files in /four/ named file1
to file1000000.

We want to move thes files to /seven/six/five. How do
you do that fast? Here's an idea. Suppose you have a
hash not only of files but of the directory sections.
Every new section is added and givem a number. For
simplicity the table might look like this:

one 1
two 2
three 3
four 4
five 5
six 6
seven 7

So what the path is reduced to is /1/2/3/4 which point
to those names. So if you want to move it then you
change the names in the database.

seven 1
six 2
five 3

And then everything that's stored as /1/2/3/4 is still
the same but the sections resolve to different names.

I'm sure there are errors in my logic but I'm trying
to show that if you are persistent in trying to come
up with ideas on how to do something you will
eventually make it work. But if you are looking for
ways to make it not work then you probably won't solve
it.

So the correct response to this message isn't to prove
that my method won't work, but to come up with a
method that will work. You have to look for a solution
rather than attack other people's solutions.

That's what thinking outside the box means.

Impossible = Challenge


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      ____________________________________________________________________________________
Park yourself in front of a world of choices in alternative vehicles. Visit the Yahoo! Auto Green Center.
http://autos.yahoo.com/green_center/ 
