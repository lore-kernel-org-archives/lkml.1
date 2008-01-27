Return-Path: <linux-kernel-owner+w=401wt.eu-S1760342AbYA0XKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760342AbYA0XKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 18:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757763AbYA0XKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 18:10:37 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:62052 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758081AbYA0XKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 18:10:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=NMrrtSwQvsxFCXJ5JMv9eW66sNJAcNOiv3ZUiH9osXd/kvBn11ixxh2ILShZejCE3xEuaNxBQ/ow2b4SNFAUXSJFji2qm4phAdgahuFmvy+m2vvnbQJZ2wgtTVbz5PqydvsO2rdjU2E+Jdw4e15LSxINiOdm6GFhHyJRxYXBjpk=
Date: Sun, 27 Jan 2008 19:10:33 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: X fails to start with latest Linus git
Message-Id: <20080127191033.b883c595.kjwinchester@gmail.com>
In-Reply-To: <20080127123702.GB21282@elte.hu>
References: <479BCE03.6070603@gmail.com>
	<479BD1D1.8020503@gmail.com>
	<20080127062703.GA23444@elte.hu>
	<20080127083129.c14452ca.kjwinchester@gmail.com>
	<20080127123702.GB21282@elte.hu>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2008 13:37:02 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Kevin Winchester <kjwinchester@gmail.com> wrote:
> 
> > Sure, the result of the script is at
> > 
> > http://personal.nbnet.nb.ca/kwin/cfs-debug-info-2008.01.27-08.13.28
> 
> it seems you've got hpet active by default:
> 
>  /sys/devices/system/clocksource/clocksource0/current_clocksource:
>  hpet
>  /sys/devices/system/clocksource/clocksource0/available_clocksource:
>  hpet acpi_pm pit jiffies tsc
> 
> do you get a similar lockup if you use acpi_pm? You can do that either 
> by disabling the HPET options in your .config, or by doing this prior 
> starting up X:
> 
>   echo acpi_pm > /sys/devices/system/clocksource/clocksource0/current_clocksource
> 

Since X was being autostarted when the computer booted, I just removed
"hpet=force" from my command line instead.  The result was that the
lockup happened earlier, so that it was before X was being started.  So
I guess X is not the culprit.

-- 
Kevin Winchester <kjwinchester@gmail.com>
