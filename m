Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbYAHH2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbYAHH2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 02:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbYAHH16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 02:27:58 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:1165 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbYAHH15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 02:27:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=wuEuxeO+tMe4fMAXBzZZZZ4WsEK9qePXE9sxqPwwEECtSTqIjwDrdDc2ApJm9tNZ569e1Wn0iUc2xIG3lCDEJvXWd8xnNm3XoiQp/pbGOPAKK1T27PFSYzFgDEYCjQsiJXYMODm2icCpcW3TGCdFH6TdACpKutATUtlYb1rb/Xo=
Date: Tue, 8 Jan 2008 08:33:59 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Winchester <kjwinchester@gmail.com>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>, gregkh@suse.de, neilb@suse.de
Subject: Re: Top 10 kernel oopses for the week ending January 5th, 2008
Message-ID: <20080108073359.GA1920@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108055917.GZ27894@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-01-2008 06:59, Al Viro wrote:
> On Mon, Jan 07, 2008 at 07:26:12PM -0800, Linus Torvalds wrote:
>  
>> I usually just compile a small program like
>>
>> 	const char array[]="\xnn\xnn\xnn...";
>>
>> 	int main(int argc, char **argv)
>> 	{
>> 		printf("%p\n", array);
>> 		*(int *)0=0;
>> 	}
> Heh.  I prefer
> char main[] = {.....};
> for the same thing, with gdb a.out and no running at all.
...

IMHO, it would be really wasteful if Arian havn't published these
and maybe a few more such advices and links on this site, not
necessarily waiting for html-ized or howto-ized versions!

Thanks,
Jarek P.
