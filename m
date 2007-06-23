Return-Path: <linux-kernel-owner+w=401wt.eu-S1751844AbXFWDwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbXFWDwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 23:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXFWDwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 23:52:30 -0400
Received: from smtpout.mac.com ([17.250.248.175]:56626 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbXFWDw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 23:52:29 -0400
In-Reply-To: <20070619150824.GH11781@holomorphy.com>
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com> <20070619150824.GH11781@holomorphy.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8E4F75AB-FA08-46ED-B29F-9251ACB1A6EE@mac.com>
Cc: Albert Cahalan <acahalan@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: JIT emulator needs
Date: Fri, 22 Jun 2007 23:52:12 -0400
To: William Lee Irwin III <wli@holomorphy.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 19, 2007, at 11:08:24, William Lee Irwin III wrote:
> On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:
>> c. open() flag to unlink a file before returning the fd
>
> You probably want a tmpfile(3) -like affair which never has a  
> pathname to begin with. It could be useful for security purposes  
> more generally.

maybe this: open("/some/dir", O_TMPFILE);
and this? open("/some/dir", O_TMPFILE|O_DIRECTORY);

The former would return a filehandle to a new anonymous file  
somewhere on whatever filesystem backs the specified path.  The  
latter would do the same, except create an anonymous directory where  
you could use "openat()" or something.  Presumably "lsof" and "/proc"  
should show either type of handle as referring to either "/some/ 
filesystem/" or "/some/filesystem/ (anonymous temp file)" or something.

Cheers,
Kyle Moffett


