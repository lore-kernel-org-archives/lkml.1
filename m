Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbYE1DP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbYE1DP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 23:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYE1DPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 23:15:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:52092 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYE1DPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 23:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=A7JQGKtwm+W76pT9vg4U2Zwov8cqI3HABWAo/X4Ph79DZBzhZEo6pYYIHun2rOpxFdwwSwKs0eah9BEc3+6SNAGgABsjgxwQVGIdLYBDpKotxNoOmMAAZ0a+WN6dhb8JDAR0aUeeiDOBrj8jmlru4mF9l1lTfvd/lFZ9+erpp+0=
Message-ID: <dcf6addc0805272015w1f60457bic919ee3acc79d0fb@mail.gmail.com>
Date: Wed, 28 May 2008 11:15:12 +0800
From: "Jun Ma" <sync.jma@gmail.com>
To: "Manuel Lauss" <mano@roarinelk.homelinux.net>
Subject: Re: MIPS kernel hangs: Warning: unable to open an initial console. /sbin/init
Cc: abhiruchi.g@vaultinfo.com, linux-kernel@vger.kernel.org,
       "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
       kernel-testers <kernel-testers@vger.kernel.org>
In-Reply-To: <20080515133855.GA20300@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <55815.192.168.1.71.1210856139.webmail@192.168.1.71>
	 <20080515133855.GA20300@roarinelk.homelinux.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 9:38 PM, Manuel Lauss
<mano@roarinelk.homelinux.net> wrote:
> On Thu, May 15, 2008 at 08:55:39AM -0400, abhiruchi.g@vaultinfo.com wrote:
>> Hi,
>>
>> My kernel hangs by initializing the system. My target is Alchemy DB1200. I use crosstool-ng to build MIPS cross toolchain and ptxdist to build ext2 filesystem.
>> kernel version:linux-2.6.22
>
> Try and add "console=ttyS0,115200" to the kernel commandline (either in
> yamon or kernel config).
>
>

And you must have a tty node in your /dev directory, e.g. /dev/ttyS0


-- 
FIXME if it is wrong.
