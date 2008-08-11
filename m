Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbYHKIkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbYHKIkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 04:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYHKIkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 04:40:07 -0400
Received: from main.gmane.org ([80.91.229.2]:46534 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbYHKIkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 04:40:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: Segmentation fault details?
Date: Mon, 11 Aug 2008 09:36:33 +0100
Message-ID: <g7otmh$h3o$2@ger.gmane.org>
References: <ac94cb270808102334m1cc2c3a1n45202072d309927c@mail.gmail.com> <ac94cb270808102337i5febf70fkb6d1f27f71cafb34@mail.gmail.com> <ac94cb270808102355o1413f46ehcddb82ae69458c0d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 86.53.68.233
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang Yi wrote:

> Hi, all!
> 
>  I'd like to know some details about segmentation fault.
>  What I mean is when a program accesses invalid memory area, it will
> get a SIGSEGV signal from kernel, and a message "Segmentation fault".
> 
>  I also find that dmesg can show we something like this:
>  ProgramName[Pid]: segfault at xxxx eip xxxx esp xxxx error x
>  It is useful and provides the first-step information for further
> debug/analysis.
> 
>  My question is how dmesg gets the information, and if there are any
> "decent" way to get this and maybe more information(An "indecent" way
> I came to is grep dmesg)
> so that I can perform some basic auto analysis.
> 
>  Thank you.
> 
> Leo

Core dumps.

You might also like to look at Ubuntu's "apport" bug reporting tool.  IIRC
the necessary kernel support is now in mainline.  I believe it provides the
option to dump core by piping it through an arbitrary program.  The aim of
apport is to capture these core dumps, notify the user, and give them the
option to submit it to the Ubuntu developers.

One advantage of this last feature is that you don't need to search the
filesystem for core files.  (They're dumped in the current directory, but
you may not know what directory the program was in when it crashed).

Alan

