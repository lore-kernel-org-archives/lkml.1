Return-Path: <linux-kernel-owner+w=401wt.eu-S966236AbXDGSZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966236AbXDGSZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 14:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966253AbXDGSZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 14:25:30 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:54423 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966236AbXDGSZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 14:25:28 -0400
Date: Sat, 7 Apr 2007 11:26:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: bbpetkov@yahoo.de
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel-doc: handle arrays with arithmetic expressions
 as initializers <was Re: [PATCH v2] kernel-doc: handle spaces in array
 size>
Message-Id: <20070407112604.808029ea.randy.dunlap@oracle.com>
In-Reply-To: <20070407150444.GC4048@gollum.tnic>
References: <20070406114730.02c82f43.randy.dunlap@oracle.com>
	<Pine.LNX.4.61.0704062117460.6042@yvahk01.tjqt.qr>
	<20070406160335.e125e287.randy.dunlap@oracle.com>
	<Pine.LNX.4.61.0704070138350.22181@yvahk01.tjqt.qr>
	<20070406175325.4bb3c904.randy.dunlap@oracle.com>
	<20070407150444.GC4048@gollum.tnic>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Apr 2007 17:04:44 +0200 Borislav Petkov wrote:

> 
> In a different approach here's a patch that handles the special case of
> composite arithmetic expressions in array size initializers. With it,
> prior to pushing the split strings on the @first_arg array, I split the
> keywords before the array name as before and then keep the array name
> along with the subscript expression as a single whole element which gets
> pushed last. In this manner, kernel-doc produces correct output without
> removing whitespaces which makes the array subscripts unreadable in the docs.

Nice job.

Andrew, please drop kernel-doc-handle-spaces-in-array-size.patch
and I'll (re)send this one to you.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
