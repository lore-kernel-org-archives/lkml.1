Return-Path: <linux-kernel-owner+w=401wt.eu-S965499AbXA3OYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965499AbXA3OYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965497AbXA3OYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:24:41 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45966 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965472AbXA3OYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:24:39 -0500
Message-ID: <45BF5525.5040709@garzik.org>
Date: Tue, 30 Jan 2007 09:24:37 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata: fix translation for START STOP UNIT
References: <45BD4E0A.7060501@shaw.ca>
In-Reply-To: <45BD4E0A.7060501@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Applies to 2.6.20-rc6.
> 
> ---
> 
> libata's SCSI translation for the SCSI START STOP UNIT command with the 
> START bit clear (i.e. stopping the drive) appears to be incorrect. It 
> sends an ATA STANDBY command with the time period set to 0, which the 
> code comment says means "now", but the ATA standard says this means 
> disable the standby timer, which effectively does nothing. Change this 
> to issue a STANDBY IMMEDIATE command which will actually spin the drive 
> down. The SAT (SCSI/ATA Translation) standard revision 9 concurs with 
> this choice.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

FWIW, I am having to apply Andrew Morton's version of your patches, 
because your patch form isn't quite right.  Review 
Documentation/SubmittingPatches and http://linux.yyz.us/patch-format.html

Most notably:

* Your patch description follows the "---" terminator, which is 
precisely the opposite of what should happen.  In the correct form, any 
comments such as "Applies to 2.6.20-rc6" should follow the "---" 
terminator, which in turn follows the patch description and signoff.

* Include the patch inline rather than as an attachment.  Even a 
text/plain attachment is very difficult to review and quote in popular 
email programs.

	Jeff


