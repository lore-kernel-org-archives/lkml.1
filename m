Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbXJ3WqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbXJ3WqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXJ3Wpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:45:55 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:37182 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbXJ3Wpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:45:53 -0400
From: Junio C Hamano <junio@pobox.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [git patches] libata fixes
References: <20071030184502.GA27246@havoc.gtf.org>
	<alpine.LFD.0.999.0710301151000.30120@woody.linux-foundation.org>
	<47278206.2080601@garzik.org>
	<alpine.LFD.0.999.0710301225370.30120@woody.linux-foundation.org>
	<Pine.LNX.4.64.0710302045310.31325@fbirervta.pbzchgretzou.qr>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Mikael Pettersson <mikpe@it.uu.se>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Date: Tue, 30 Oct 2007 15:45:42 -0700
In-Reply-To: <Pine.LNX.4.64.0710302045310.31325@fbirervta.pbzchgretzou.qr>
	(Jan Engelhardt's message of "Tue, 30 Oct 2007 20:46:25 +0100 (CET)")
Message-ID: <7v1wbckyqx.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:

> On Oct 30 2007 12:31, Linus Torvalds wrote:
>>On Tue, 30 Oct 2007, Jeff Garzik wrote:
>>> 
>>> Can we change git-am to accept two dashes as well as three?  :)
>>
>>Well, git-am actually used to be a lot less strict about the dashes, and 
>>we've made it *more* strict rather than less, because the more of these 
>>breaks we accept, the more likely it is that something that was intended 
>>to be part of the message gets thrown out.. So I'll say that I'm a bit 
>>nervous about extending it again.
>
> I would not add --. It is already used ("-- " is) in the mail world as a
> signature separator. Let's stay with ---, which is also what quilt generates.

Thanks for the input about what quilt does.

So the way to proceed is to have no change to mailinfo, and have
a bit of user education.
