Return-Path: <linux-kernel-owner+w=401wt.eu-S1761538AbXFAO36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761538AbXFAO36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 10:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758615AbXFAO3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 10:29:51 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:2273 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758595AbXFAO3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 10:29:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fnQ1jTDe9CoZZBLqGuMxyrGKErbw5jw7IWiw89e7Gs1wuwrgBOXlpHgu3mXeip08Gv9xoJC+z/+/hXKbUtabtqGGxeKl8V+WY+rHZLbb9J+2mNcwMA9YtIJVCf14Dh0AjcbHuSwdYFU21UnVhmtThFvp1lhAUWdCmDNfTOhVkL8=
Message-ID: <25ae38200706010729t10d68b99v10dcd9b5a190f4f0@mail.gmail.com>
Date: Fri, 1 Jun 2007 19:59:49 +0530
From: "Anand Jahagirdar" <anandjigar@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: Patch related with Fork Bombing Atack
Cc: "Jens Axboe" <jens.axboe@oracle.com>, security@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706011032490.29896@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25ae38200705310645n5e913a91weaa14521908f7989@mail.gmail.com>
	 <20070531134611.GZ32105@kernel.dk>
	 <25ae38200705312348r3cd02c90h5080617fa1f0a987@mail.gmail.com>
	 <Pine.LNX.4.64.0706011032490.29896@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All

                I totally agree with all of you, but my idea behind
this patch is that administrator/root user must be able to know that
there is fork bombing attack on his machine and he should be able take
action agianst that particular user and kill all his processes.

can anybody please tell me how can we achive this??

Regards
Anand

On 6/1/07, Jiri Kosina <jikos@jikos.cz> wrote:
> On Fri, 1 Jun 2007, Anand Jahagirdar wrote:
>
> >     when they try to flood the syslog using fork bombing attack, their
> > messge will be printed only once in syslog and it will show how many
> > times it has repeated. due to this he will not able to flood the
> > syslog.and i am using only one single variable in my printk messge so it
> > is quite not possible to flood the syslog.
>
> Your argument is flawed - if the kernel provides more than one possibility
> to flood the syslogd, the is free to invoke the events interleaved. This
> trivially prevents syslogd from grouping identical reports together.
>
> --
> Jiri Kosina
>
