Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbYJaIYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbYJaIYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 04:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbYJaIYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 04:24:19 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:39634 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbYJaIYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 04:24:18 -0400
Date: Fri, 31 Oct 2008 08:24:14 +0000
From: Andy Whitcroft <andyw@uk.ibm.com>
To: Dotan Barak <dotanba@gmail.com>
Cc: linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: checkpatch.pl print the line twice when trailing statements in
	the same line
Message-ID: <20081031082414.GD26593@brain>
References: <200810202051.38694.dotanba@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810202051.38694.dotanba@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 08:51:38PM +0200, Dotan Barak wrote:
> Hi.
> 
> I executed checkpatch.pl version 0.24 on a file and i noticed that when
> a tailing statement is being declared at the same line with "while, checkpatch
> prints the erroneous line twice.
> 
> Here is an example of the output:
> 
> ERROR: trailing statements should be on next line
> #651: FILE: idbm.c:651:
> +               while (*nl && isspace(c = *nl)) nl++;
> +               while (*nl && isspace(c = *nl)) nl++;
> 
> Is this is the expected behavior?

No that would definintaly not be expected.  Will add it to my TODO list.

Thanks for the report.

-apw
