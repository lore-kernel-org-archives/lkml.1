Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbZEIC5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbZEIC5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 22:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbZEIC5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 22:57:12 -0400
Received: from ellpspace.math.ualberta.ca ([129.128.207.67]:37308 "EHLO
	ellpspace.math.ualberta.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbZEIC5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 22:57:12 -0400
Date: Fri, 8 May 2009 20:56:43 -0600
From: Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Mario Lang <mlang@tugraz.at>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: Asus Eee 901Go ACPI errors on 2.6.30-rc4-git4
Message-ID: <20090509025643.GA24335@ellpspace.math.ualberta.ca>
References: <87vdobq48p.fsf@fzidpc73.tu-graz.ac.at> <9b2b86520905080646r85f30bcp6f50d7388d8289f5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2b86520905080646r85f30bcp6f50d7388d8289f5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 02:46:05PM +0100, Alan Jenkins wrote:
> On 5/8/09, Mario Lang <mlang@tugraz.at> wrote:
> >
> > Booting 2.6.30-rc4-git4 on an Asus Eee 901Go I get the following in dmesg:
> >
> > [   27.005071] ACPI: EC: missing confirmations, switch off interrupt mode.
> > [   27.548097] ACPI Exception (evregion-0422): AE_TIME, Returned by Handler
> > for [EmbeddedControl] [20090320]
> > [   27.548139] ACPI Error (psparse-0537): Method parse/execution failed
> > [\_SB_.PCI0.SBRG.EC0_.BST1] (Node f7033d4c), AE_TIME
> > [   27.548280] ACPI Error (psparse-0537): Method parse/execution failed
> > [\_SB_.PCI0.CBST] (Node f70366f8), AE_TIME
> > [   27.548393] ACPI Error (psparse-0537): Method parse/execution failed
> > [\_SB_.PCI0.BAT0._BST] (Node f7034c48), AE_TIME
> > [   27.548521] ACPI Exception (battery-0385): AE_TIME, Evaluating _BST
> > [20090320]
> 
> Odd.  Did this happen in 2.6.29?

I have seen something similar with different kernels.  See for example
https://bugzilla.redhat.com/show_bug.cgi?id=492699
which reports that for kernel-2.6.27.19-170.2.35.fc10 and
kernel-2.6.29-3.fc10 Fedora kernels and Asus Eeeps 1002HA.

https://bugzilla.redhat.com/buglist.cgi?quicksearch=+Method+parse%2Fexecution+failed

brings a list where it is possible to find something of that sort
in different settings too.

    Michal
