Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbXF3FSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbXF3FSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 01:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbXF3FSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 01:18:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47518 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbXF3FSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 01:18:12 -0400
Subject: Re: how to determine if the noexec stack is defined by an
	application
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
In-Reply-To: <4685B00E.3030700@andrei.myip.org>
References: <46856F24.5060407@andrei.myip.org>
	 <1183153758.2894.1.camel@laptopd505.fenrus.org>
	 <4685B00E.3030700@andrei.myip.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 29 Jun 2007 22:16:15 -0700
Message-Id: <1183180575.2894.8.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-29 at 18:21 -0700, Florin Andrei wrote:
> Arjan van de Ven wrote:
> >> But it's running a Web service which is a combination of C code and 
> >> Tomcat/Java. I have no clue how to determine which portions specify a 
> >> noexec stack and which don't.
> > 
> > like this:
> > 
> > $ eu-readelf -l /bin/true  | grep STACK
> >   GNU_STACK      0x000000 0x00000000 0x00000000 0x000000 0x000000 RW 0x4
> 
> Is Sun Java 1.5 a known exception - as an application that doesn't set a 
> noexec stack and reverts to default?
> 
> # eu-readelf -l ./java | grep STACK | wc -l
> 0
> 
> But then, this bug report seems to indicate otherwise, if I'm reading it 
> correctly:
> 
> http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=5051381


that's not a mainline kernel; and I don't rule out that early RHEL3
versions had a 64/32 bug in this area
> 
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

