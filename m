Return-Path: <linux-kernel-owner+w=401wt.eu-S965411AbXBFAtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965411AbXBFAtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965426AbXBFAtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:49:12 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:33231 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965411AbXBFAtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:49:09 -0500
Date: Mon, 5 Feb 2007 16:48:42 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Scot McKinley <scot.mckinley@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       bert hubert <bert.hubert@netherlabs.nl>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070206004842.GS32307@ca-server1.us.oracle.com>
Mail-Followup-To: Scot McKinley <scot.mckinley@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	bert hubert <bert.hubert@netherlabs.nl>,
	Davide Libenzi <davidel@xmailserver.org>,
	Ingo Molnar <mingo@elte.hu>, Zach Brown <zach.brown@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
	Benjamin LaHaise <bcrl@kvack.org>
References: <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021525370.5219@alien.or.mcafeemobile.com> <20070205213618.GA30923@outpost.ds9a.nl> <Pine.LNX.4.64.0702051350010.8424@woody.linux-foundation.org> <45C7CB80.4040402@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C7CB80.4040402@oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 04:27:44PM -0800, Scot McKinley wrote:
> Finally, it is agreed that neg-errno is a much better approach for the 
> return code. The threading/concurrency issues associated w/ the current 
> unix errno has always been buggy area for Oracle Networking code.

	As Scot knows, when Oracle started using the current io_submit(2)
and io_getevents(2), -errno was a big win.

Joel

-- 

"Born under a bad sign.
 I been down since I began to crawl.
 If it wasn't for bad luck,
 I wouldn't have no luck at all."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
