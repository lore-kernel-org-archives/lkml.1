Return-Path: <linux-kernel-owner+w=401wt.eu-S965065AbXA3Pu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965065AbXA3Pu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965092AbXA3Pu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:50:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:2310 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965065AbXA3Pu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:50:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KH6TmRzzRLA1ezkWYhZpsS17vddz6mrntYLKH8FuyeQmMaaQwOX9ughnKBd2qpak/0Kod45Am6YirI2jSLspEM1atiwVX51zghPhttFtI8NH823QAEMfK/RIfh6ol79eNasyoeILMZGvIE1bP0pYSCoJM5L79miJ33qD4a3neV0=
Message-ID: <3efb10970701300750m22519ab1w30f2e6f468468431@mail.gmail.com>
Date: Tue, 30 Jan 2007 16:50:22 +0100
From: "Remy Bohmer" <l.pinguin@gmail.com>
Reply-To: linux@bohmer.net
To: linux-kernel@vger.kernel.org
Subject: Fwd: [OOPS] on 2.6.20-rc5-rt10
In-Reply-To: <3efb10970701300749h68f868eew37b115ad2719c9f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970701300630w3c235233ic7613e8f74a7b4f2@mail.gmail.com>
	 <45BF59ED.3090203@stud.feec.vutbr.cz>
	 <3efb10970701300749h68f868eew37b115ad2719c9f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Remy Bohmer <l.pinguin@gmail.com>
Date: 30 jan 2007 16:49
Subject: Re: [OOPS] on 2.6.20-rc5-rt10
To: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>


Hello Michal,

This cap_over driver is a capability driver to give certain processes
extra capabilities, this makes it possible to run them under a normal
user account. It is an inheritance from the time we used a
distribution that did not have support for SE-Linux.

You can find it at: http://www.randombit.net/projects/cap_over/

But, I do not think it is a nice solution, and I will replace it soon
by the default SELinux implementation of FC6.

Kind Regards,

Remy Bohmer


2007/1/30, Michal Schmidt <xschmi00@stud.feec.vutbr.cz>:
> Remy Bohmer wrote:
> > Hello All,
> >
> > Once in a while we see the following stacktrace.
> > We do not know yet the exact condition that generates this, but is
> > there anyone that recognises this oops?
> >
> > Kind Regards,
> >
> > Remy Bohmer
> >
> > [...]
> > Jan 30 14:09:20 localhost kernel: Modules linked in: cap_over
> > commoncap i2c_dev uhci_hcd i2c_i801 i2c_core ehci_hcd
>
> What's the cap_over module? I can't find it in my kernel anywhere.
> Michal
>
>
