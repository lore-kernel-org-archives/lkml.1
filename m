Return-Path: <linux-kernel-owner+w=401wt.eu-S934331AbXC2Tbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331AbXC2Tbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 15:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934333AbXC2Tbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 15:31:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:45135 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934331AbXC2Tbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 15:31:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=oE8Hs6hujXgQbJhmsXOb1V4V6ZoT4Dt1OFUVZKgHLBImxNeyJmVr7RtU4oH6ARnPbesSHFhe3r+0HLyJd49i5esDxkUsrGY9LNIjo7JjQ/YPF1l3gP83j6kxRB/DldzMgoqfhvrtGApXacPaBJ23gAiA1PheXfcrxkg/jvihYOE=
Message-ID: <75b66ecd0703291231n1b7cbcfcpbb16f4cfee933c2c@mail.gmail.com>
Date: Thu, 29 Mar 2007 15:31:35 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Kevin Perros" <kevin.perros@free.fr>
Subject: Re: 2.6.20.3-rt8 - DMA suffers excessive delay periodically
Cc: John <linux.kernel@free.fr>, linux-kernel@vger.kernel.org
In-Reply-To: <460C094C.8070304@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46094728.40300@free.fr>
	 <75b66ecd0703271341x34463c49w64bdac21a9741355@mail.gmail.com>
	 <460A297A.2030200@free.fr> <460C094C.8070304@free.fr>
X-Google-Sender-Auth: 2ce02bd4ce889309
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/07, Kevin Perros <kevin.perros@free.fr> wrote:
> > No it is an "indutrial" motherboard.
> > Although I don't know what makes it "industrial".
> >
> > Regards.
> >
> > Is this related to SMM?
> >
> > As far as I can tell, the BIOS is Phoenix AwardBIOS v6.00PG.
> >
> > Would someone know how to disable SMM in this BIOS?
>
> Usually you cannot disable SMM via the BIOS. You have to write chipset
> specific Kernel code for that.

The problem could also be something other than SMM, like DMA
starvation by a video or disk controller.  Try disabling all hard
drive controllers and booting from a CD or USB stick.

Also, try tweaking the expire_centisecs and writeback_centisecs values
in /proc/sys/vm and see if it changes the period of the glitches.

Lee
