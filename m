Return-Path: <linux-kernel-owner+w=401wt.eu-S1764252AbXEZQu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764252AbXEZQu1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760296AbXEZQuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:50:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54158 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbXEZQuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:50:16 -0400
Date: Sat, 26 May 2007 17:50:09 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       David Miller <davem@davemloft.net>, satyam.sharma@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: double exclamation (!!) suckage in the kernel
Message-ID: <20070526165009.GT4095@ftp.linux.org.uk>
References: <8oOAk-4mP-3@gated-at.bofh.it> <8oPmF-5Fb-21@gated-at.bofh.it> <8p4OH-3N0-15@gated-at.bofh.it> <E1HrzHL-0000s2-Pv@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HrzHL-0000s2-Pv@be1.lrz>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 06:38:07PM +0200, Bodo Eggert wrote:
> Not exactly, if(foo) is the same as if( (int) foo), which is not
> guaranteed to result in non-null values for non-null pointers.

RTFStandard.

> ISO 9899/1999 says: "Any pointer may be converted to an integer type. [...]
>          The result need not be in the range of values of any integer type."

... and it sure as hell does *NOT* say that controlling expression of
if statement is converted to an integer type.  For pointers of for anything
else.  if (v) is the same as if (v != 0) [6.8.4.1p2], and if v is a pointer,
0 in that comparison becomes a null pointer constant [6.5.9p5].
