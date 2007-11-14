Return-Path: <linux-kernel-owner+w=401wt.eu-S1762781AbXKNFd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762781AbXKNFd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 00:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbXKNFds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 00:33:48 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:16506 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbXKNFdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 00:33:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=JrdOHCfRY2L3GY77K7F6oLTGGoUmBxetBNfGnZUyhqAP+X4r9Nq5o05FRXRU+53z1ZDh+vLreoBMEdKNXsFND8ULw4hFMhT31mzkI5tP9J7g6OwcRwBt4sT76eQu1c8fXVhNtdJIoxYPzkjMmrDq1gAMxRVEFNpn1T/ymKx3z/I=
Message-ID: <473A88B3.3010303@googlemail.com>
Date: Wed, 14 Nov 2007 06:33:39 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
CC: Greg KH <greg@kroah.com>, Gabriel C <nix.or.die@googlemail.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bk@suse.de, khali@linux-fr.org
Subject: Re: 2.6.24-rc2-mm1
References: <473A678C.2020507@googlemail.com> <20071114034924.GA26048@kroah.com> <20071114043923.GK6089@one-eyed-alien.net>
In-Reply-To: <20071114043923.GK6089@one-eyed-alien.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Dharm wrote:
> On Tue, Nov 13, 2007 at 07:49:24PM -0800, Greg KH wrote:
>> Matt, are these the errors you were worried about with the patch we were
>> just talking about tha tis in my tree?
> 
> I can't tell from these logs.

There is the dmesg with CONFIG_USB_STORAGE_DEBUG :

http://194.231.229.228/dmesg-2.6.24-rc2-mm1

> 
> The key question (in relation to the allow_restart patch) is this:  Was
> everything working fine until a START_STOP was sent to the device?
> 
> The SCSI layers used to send devices START_STOP to almost every device as
> part of initialization.  I think we switched all of that to use
> TEST_UNIT_READY instead.
> 
> The patch you've got should re-enable START_STOP to be sent.  The SCSI
> layers (I'm told, but haven't verified myself) only send START_STOP if the
> device reports that it needs a startup command.
> 
> CONFIG_USB_STORAGE_DEBUG will generate a *lot* of debug output.  But, it
> should be pretty easy to see if START_STOP was sent at all, and if it
> caused the problems.
> 
> Matt
> 
> P.S. Worst case, the issue we're talking about here would only cause the
> device firmware to crash, which would eventually lead to a disconnect.
> That shouldn't have caused the much more severe problems shown in the log
> you sent.
> 


Gabriel
