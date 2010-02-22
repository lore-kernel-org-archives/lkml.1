Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0BVUR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:17:29 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:49225 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab0BVUR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:17:27 -0500
Date: Mon, 22 Feb 2010 21:17:25 +0100
Message-Id: <1155618003@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: Atul.Mukker@lsi.com, Manoj.Jose@lsi.com, Sreenivas.Bagalkote@lsi.com,
       Robert Hancock <hancockrwd@gmail.com>, sju@lsil.com
Subject: Re: [BUG]  smartd crashing recent 2.6.32 kernel
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+fUrfIwGcWxkwkM1bHSy6/KFgrG9ELM0fCHFMWVa8QFmbIi
 lI/JcXwSIycDTcwWzpFTk9Sma12G2dqDWQFgHUGP6VpcTe+UE8=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently,  i´m not alone:

http://bugzilla.kernel.org/show_bug.cgi?id=12544

as my box is definitely into production at the start of next week, cc`ing driver authors (found in source) as last resort. so, last chance to have a box to reproduce for ~1 week.

btw, http://megaraid.lsilogic.com in MAINTAINERS seems down. server problem or website cancelled?

regards
roland

3542 MEGARAID SCSI DRIVERS
3543 M:      Neela Syam Kolli <megaraidlinux@lsi.com>
3544 L:      linux-scsi@vger.kernel.org
3545 W:      http://megaraid.lsilogic.com
3546 S:      Maintained
3547 F:      Documentation/scsi/megaraid.txt
3548 F:      drivers/scsi/megaraid.*
3549 F:      drivers/scsi/megaraid/

12  * FILE         : megaraid_mbox.c
13  * Version      : v2.20.5.1 (Nov 16 2006)
14  *
15  * Authors:
16  *      Atul Mukker             <Atul.Mukker@lsi.com>
17  *      Sreenivas Bagalkote     <Sreenivas.Bagalkote@lsi.com>
18  *      Manoj Jose              <Manoj.Jose@lsi.com>
19  *      Seokmann Ju



List:       linux-kernel
Subject:    Re: [BUG]  smartd crashing recent 2.6.32 kernel
From:       Robert Hancock <hancockrwd () gmail ! com>
Date:       2010-02-20 1:16:42
Message-ID: 4B7F37FA.2050608 () gmail ! com
[Download message RAW]

Adding CCs. Looks like a megaraid_mbox bug..

On 02/19/2010 04:13 PM, devzero@web.de wrote:
> as time goes by, no real attempt or progress has been made to fix bug #15171. ( \
> http://bugzilla.kernel.org/show_bug.cgi?id=15171 ) 
> when smartd starts, the kernel crashes with this trace:
> https://bugzillafiles.novell.org/attachment.cgi?id=338427
> 
> the machine with this problem will be go into production very soon, so if anybody \
> want`s to help on fixing this - we have a few days left...... \
> ______________________________________________________ GRATIS für alle \
> WEB.DE-Nutzer: Die maxdome Movie-FLAT! Jetzt freischalten unter \
> http://movieflat.web.de 

______________________________________________________
GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

