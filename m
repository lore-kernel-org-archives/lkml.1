Return-Path: <linux-kernel-owner+w=401wt.eu-S1762312AbXFECKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762312AbXFECKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 22:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbXFECKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 22:10:07 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:52808 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867AbXFECKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 22:10:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=SKi/AegZy3QQ6OLUieevpnpyYFhHg0RNyUgYqM5RThyN85Niws+9Pkkmt5KpMhf+tJlf7aJSapoV3rO9keTREQPjkREz17zM04PHHd95UUccQNlEq4Qnv+qvycSijOYNaSctx/prt6c0+eO65/2vAQZAadjJbPkH8i7ty8er6oY=
Date: Tue, 5 Jun 2007 10:10:27 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <rdunlap@xenotime.net>, Al Viro <viro@ftp.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
Message-ID: <20070605021027.GD2498@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Al Viro <viro@ftp.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <46644B97.2010506@zytor.com> <Pine.LNX.4.61.0706041935290.20829@yvahk01.tjqt.qr> <46644F57.80005@zytor.com> <20070604175751.GB3437@dhcp83-182.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604175751.GB3437@dhcp83-182.boston.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 01:57:51PM -0400, Jeff Garzik wrote:
>On Mon, Jun 04, 2007 at 10:43:51AM -0700, H. Peter Anvin wrote:
>> Jan Engelhardt wrote:
>> > On Jun 4 2007 10:27, H. Peter Anvin wrote:
>> >> Jeff Garzik wrote:
>> >>> Seconded.  All my code contains the goto label in the first column.
>> >>>
>> >>> IMO any other goto label indentation is silly, because it obscures the
>> >>> goto label within the code block.
>> >> I would have to disagree with this.  IMNSHO, a goto label is like a case
>> >> label, and they should be treated the same way.
>> > 
>> > But gotos are special. ("Evil" minus the "it's good for unrolling in case of an
>> > error" case).
>> > 
>> 
>> So?
>> 
>> You still want them to be associated with the level the bailout happens at.
>
>A matter of opinion :)  I tend to think goto is special enough to
>warrant column 1 unconditionally.  It is special, so it draws additional
>attention over and above case labels.
>
>I and others have been tripped up when programmers "hide" goto
>statements among regular statements.
>
>IMO goto warrants a big flashing "notice me" sign.
>
>	Jeff

Hmmm, perhaps.

So, it seems that we can reach an agreement. Any other comments or suggestions?
Or can someone ack/merge this patch?

Thanks!

