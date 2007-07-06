Return-Path: <linux-kernel-owner+w=401wt.eu-S1761760AbXGFEOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761760AbXGFEOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 00:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbXGFEOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 00:14:32 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:57279 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbXGFEOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 00:14:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=mMbiMWbnAjJ476huSs96XsZxHnooUSrO3iEDC5hmxDznO5QqKv8KXIQgiXW8Vs2B3VqQ/tr13NA95JvlD7qSxiDbnW9z5vN+6CHtm6/aQZj/v0EhBXuaQU2+bc4yylYWisJsHyBH+JUBfZugaI4rOdGOGMYhWwDyDAN0jMrJGDc=
Message-ID: <a71bd89a0707052114u28fed408h4326913c502a43ac@mail.gmail.com>
Date: Thu, 5 Jul 2007 21:14:29 -0700
From: "Dan Kegel" <dank@kegel.com>
To: linux-kernel@vger.kernel.org
Subject: Valgrinding the kernel?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 7ce7af0d3512780d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It'd be nice to see if Valgrind could catch uninitialized
references in the kernel, if only to see if Coverity is
missing anything that happens in practice.

Back in December 2002, Valgrind started to run UML:
http://user-mode-linux.sourceforge.net/diary.html
http://marc.info/?l=linux-kernel&m=104035199923121&w=2
but it wasn't quite usable, and it seems broken since then.
The last note I could find about this was from Jeff In July 2005:
http://marc.info/?l=linux-kernel&m=112273702329952&w=2

Has there been any motion since then?

Thanks,
Dan
