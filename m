Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbXKRWNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbXKRWNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 17:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXKRWNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 17:13:05 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:53608 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbXKRWNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 17:13:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=V2sIDLDfPmKLqxu9ZIuRCpyu3mxFbPyWkJGMNZqpV+AeLtH02QBejwbW8CkcFff4455+HOtal1qXu8xAgkBvF4wS6w8cfMWId32vuJdY4TxcaxbTU2CH3AFrirOGVQLhSlsfxCeqWavJx9MChsjEvuOxeVxCHK6E08DHIlkOe4s=
Message-ID: <4740B8E9.4030903@gmail.com>
Date: Sun, 18 Nov 2007 23:12:57 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
References: <Pine.LNX.4.44L0.0711181203220.5712-100000@netrider.rowland.org> <47408DFF.9070701@gmail.com> <200711182328.00570.rjw@sisk.pl>
In-Reply-To: <200711182328.00570.rjw@sisk.pl>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2007 11:27 PM, Rafael J. Wysocki wrote:
> You can use a global variable to switch the logging only before the CPU
> hotunplug done by the suspend code.  You just need to hack
> disable_nonboot_cpus() for that.

If I understand you correctly, that's what BUBAK variable is there for. But it
is still called again and again while the suspend code runs...

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
