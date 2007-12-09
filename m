Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbXLIQLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbXLIQLe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 11:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbXLIQLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 11:11:25 -0500
Received: from smtp108.plus.mail.re1.yahoo.com ([69.147.102.71]:30168 "HELO
	smtp108.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750998AbXLIQLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 11:11:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=2eL5FgMC49Rj3uDLDuWS9y4b/U0VozTxUcUrDyAtV8642t75JQQIOtY6y5oMghd5QAlfSqujzDJcMc35GvrdwFkKtmABc0YuvPj8QR0zH/9tALgdk0DExZbAPmsccHMn8aN3RkZr6O5b7JyJyyHI0mF1BU9VEl326LTrw9ARTbM=  ;
X-YMail-OSG: JepKdHsVM1k7q_VHTRpUYBFhyIRguomo5CfXeJiu6LaTWNYpfmQfn8tRfC.m1Q.KPEidSv0GIA--
Date: Sun, 9 Dec 2007 17:09:59 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] swap image signature check upon resume
Message-ID: <20071209160959.GA4978@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
References: <20071206211335.GA4923@gollum.tnic> <200712082350.33626.rjw@sisk.pl> <20071209065559.GA4627@gollum.tnic> <200712091527.57523.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200712091527.57523.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2007 at 03:27:57PM +0100, Rafael J. Wysocki wrote:
...

> > Instead, I'd rather issue a warning that the swsusp header mismatches, say with
> > which kernel the machine got suspended with and then start the countdown for reboot.
> 
> What exactly would that change?  You need to reboot anyway and fsck will run on
> the filesystems regardless of which kernel you boot with.

well, you'll have the chance to reboot with the kernel the machine got suspended
with and then the swsusp image header _will_ match so no fsck-ing. or am i
missing something...

-- 
Regards/Gruﬂ,
    Boris.
