Return-Path: <linux-kernel-owner+w=401wt.eu-S933659AbYETVTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659AbYETVTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758124AbYETVTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:19:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:41785 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729AbYETVTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HMkJc+WJ3I3cxW9Z6mAKESPQMjHLwdXaCnPx0s1cccdjNOVae1Xgy2832HlT1q3Yg+Idb8nScxkFK0PRJMk7KB3b1QtYD1S69WGxruzPDF8j5dD49NOpELf6D6wYwusVIOek3xNlDd3xshzqyFKJsAom+CL+X3rYtnJqAJlks1A=
Message-ID: <2c0942db0805201419q2b4c3771m5bc54a9dc243e9e6@mail.gmail.com>
Date: Tue, 20 May 2008 14:19:03 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Lee Howard" <faxguy@howardsilvan.com>
Subject: Re: troubleshooting/debugging hard locks
Cc: "Zan Lynx" <zlynx@acm.org>, linux-kernel@vger.kernel.org
In-Reply-To: <483338DE.8090904@howardsilvan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <482B3D21.5020903@howardsilvan.com>
	 <2c0942db0805141543n20e6eb6eq5fe13fe1cb50d67e@mail.gmail.com>
	 <1210808578.3784.7.camel@localhost>
	 <482BB151.4010109@howardsilvan.com>
	 <483338DE.8090904@howardsilvan.com>
X-Google-Sender-Auth: 281d36e01a76d6cf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 1:47 PM, Lee Howard <faxguy@howardsilvan.com> wrote:
> After further troubleshooting it turns out that the message above was a bit
> of a red herring.  I moved the PCIe modem card from one PCIe slot to another
> so that it would be on a different IRQ (one that wasn't shared with the
> network, ATA, and USB).  The message above does not occur now, however, the
> hard lock is back... and this time with no kernel messages at all.
>
> So, I'm back to square one again... I've got:
>
>  nmi_watchdog=1 idle=poll nohz=off
>
> ... and still I get the hard lockup and no kernel messages.  How do I
> troubleshoot/debug this?  How do I know where to look?

The only thing I can think of is to recompile the latest mainline
kernel with all debugging options enabled in the .config. and then try
to reproduce with that.
