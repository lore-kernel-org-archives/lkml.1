Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbXFXENL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbXFXENL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 00:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbXFXENB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 00:13:01 -0400
Received: from holomorphy.com ([66.93.40.71]:42396 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbXFXENA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 00:13:00 -0400
Date: Sat, 23 Jun 2007 21:14:24 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Albert Cahalan <acahalan@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: JIT emulator needs
Message-ID: <20070624041424.GK6909@holomorphy.com>
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com> <20070619150824.GH11781@holomorphy.com> <8E4F75AB-FA08-46ED-B29F-9251ACB1A6EE@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8E4F75AB-FA08-46ED-B29F-9251ACB1A6EE@mac.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
>>> c. open() flag to unlink a file before returning the fd

On Jun 19, 2007, at 11:08:24, William Lee Irwin III wrote:
>> You probably want a tmpfile(3) -like affair which never has a  
>> pathname to begin with. It could be useful for security purposes  
>> more generally.

On Fri, Jun 22, 2007 at 11:52:12PM -0400, Kyle Moffett wrote:
> maybe this: open("/some/dir", O_TMPFILE);
> and this? open("/some/dir", O_TMPFILE|O_DIRECTORY);
> The former would return a filehandle to a new anonymous file  
> somewhere on whatever filesystem backs the specified path.  The  
> latter would do the same, except create an anonymous directory where  
> you could use "openat()" or something.  Presumably "lsof" and "/proc"  
> should show either type of handle as referring to either "/some/ 
> filesystem/" or "/some/filesystem/ (anonymous temp file)" or something.

This is plausible (and I did indeed consider the file variant),
though it may require more infrastructure than for tmpfs only.

It may be worth clarifying that I have no concrete plans to work on
the JIT emulator issues myself. I'm only disseminating ideas I think
will pass review. I expect others to take up the issue(s) perhaps with
some inspiration from what I described. I may review some, but I have
a large review backlog as things now stand.


-- wli
