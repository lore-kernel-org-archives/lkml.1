Return-Path: <linux-kernel-owner+w=401wt.eu-S934601AbXJSC5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934601AbXJSC5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 22:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763538AbXJSC5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 22:57:21 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:33755 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761103AbXJSC5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 22:57:20 -0400
Message-ID: <47181D0C.3040504@davidnewall.com>
Date: Fri, 19 Oct 2007 12:27:16 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: jaroslav.sykora@gmail.com, Jan Engelhardt <jengelh@computergmbh.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Shadow directories
References: <200710181721.09201.jara@sin.cvut.cz> <Pine.LNX.4.64.0710181802300.2936@fbirervta.pbzchgretzou.qr> <200710181907.58643.jara@sin.cvut.cz> <4717BBBB.6040205@davidnewall.com> <4717C419.8060602@davidnewall.com> <20071018204703.GQ8181@ftp.linux.org.uk>
In-Reply-To: <20071018204703.GQ8181@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Fri, Oct 19, 2007 at 06:07:45AM +0930, David Newall wrote:
>   
>>> considerations of this whole scheme. Linux, like most Unix systems, 
>>> has never allowed hard links to directories for a number of reasons;
>>>       
>> The claim is wrong.  UNIX systems have traditionally allowed the 
>> superuser to create hard links to directories.  See link(2) for 2.10BSD 
>> <http://www.freebsd.org/cgi/man.cgi?query=link&sektion=2&manpath=2.10+BSD>. 
>> Having got that wrong throws doubt on the argument; perhaps a path can 
>> simultaneously be a file and a directory.
>>     
>
> Learn to read.  Linux has never allowed that.  Most of the Unix systems
> do not allow that.

I did read the claim and it is ambiguous, in that it can reasonably be 
read to mean that most UNIX systems never allowed such links, which is 
wrong.  All UNIX systems allowed it until relatively recently.
