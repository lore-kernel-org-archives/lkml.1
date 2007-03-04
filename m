Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbXCDXlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbXCDXlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 18:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbXCDXlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 18:41:51 -0500
Received: from mcr-smtp-002.bulldogdsl.com ([212.158.248.8]:3504 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752036AbXCDXlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 18:41:50 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: CK804 SATA Errors (still got them)
Date: Sun, 4 Mar 2007 23:41:38 +0000
User-Agent: KMail/1.9.5
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
References: <200703011339.52895.s0348365@sms.ed.ac.uk> <200703021547.09121.s0348365@sms.ed.ac.uk> <45EB555C.9050606@shaw.ca>
In-Reply-To: <45EB555C.9050606@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703042341.38431.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 March 2007 23:25, Robert Hancock wrote:
> Alistair John Strachan wrote:
> >> Can you try reverting commit 721449bf0d51213fe3abf0ac3e3561ef9ea7827a
> >> (link below) and see what effect that has?
> >>
> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commi
> >>t;h =721449bf0d51213fe3abf0ac3e3561ef9ea7827a
> >
> > Obviously, I'll let you know if it happens again, but I've reverted this
> > commit and transferred 22.5GB over 45 minutes onto a RAID5 with 4 HDs on
> > an NVIDIA sata controller, and this error hasn't appeared.
> >
> > So I'm inclined to (very unscientifically) say that this brings it back
> > to 2.6.20's level of stability.
>
> Interesting. Can you try un-reverting that patch, and applying this one?

Sorry for the newbie question, but is it adequate to do a:

	git reset --hard v2.6.21-rc2

To ensure a patch is "unreverted" (I reverted it with "git revert"), before 
applying your patch?

I've done so now, assuming this _will_ work. The reason I ask is that your 
diff was offset by 12 lines versus -rc2.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
