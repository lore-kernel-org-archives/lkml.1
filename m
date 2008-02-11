Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbYBKXMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbYBKXMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYBKXMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:12:43 -0500
Received: from mail.fuw.edu.pl ([193.0.80.14]:35347 "EHLO mail.fuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbYBKXMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:12:41 -0500
From: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Organization: FUW
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: 2.6.25-rc1 regression - suspend to ram
Date: Tue, 12 Feb 2008 00:10:54 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, venkatesh.pallipadi@intel.com
References: <20080211225811.GB4343@ics.muni.cz>
In-Reply-To: <20080211225811.GB4343@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802120010.55021.Rafal.Wysocki@fuw.edu.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 11 of February 2008, Lukas Hejtmanek wrote:
> Hello,

Hi,
 
> 2.6.25-rc1 takes really long time till it suspends (about 30-40secs, used to
> be about 5 secs at all) and it is resuming about few minutes.  While resuming,
> capslock toggles the capslock led but with few secs delay.
> 
> 2.6.24-git15 was OK. 2.6.24 is OK.
> 
> I have Lenovo ThinkPad T61.

If you have CONFIG_CPU_IDLE set, please try to boot with idle=poll and see if
that helps.

Thanks,
Rafael
