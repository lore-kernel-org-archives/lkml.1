Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYBMJZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYBMJZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765451AbYBMJYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:24:32 -0500
Received: from hpsmtp-eml11.KPNXCHANGE.COM ([213.75.38.111]:14930 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760058AbYBMJYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:24:30 -0500
From: Frans Pop <elendil@planet.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Date: Wed, 13 Feb 2008 10:24:26 +0100
User-Agent: KMail/1.9.7
References: <200802111623.38478.elendil@planet.nl> <200802122245.09444.elendil@planet.nl> <20080212235442.005aea9e.akpm@linux-foundation.org>
In-Reply-To: <20080212235442.005aea9e.akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131024.27443.elendil@planet.nl>
X-OriginalArrivalTime: 13 Feb 2008 09:24:28.0057 (UTC) FILETIME=[3B296090:01C86E22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008, you wrote:
> On Tue, 12 Feb 2008 22:45:09 +0100 Frans Pop <elendil@planet.nl> wrote:
> > Symptom is that the system shuts down normally and completely, it just
> > does not power off.
>
> I've been struggling with an identically-manifesting regression on one of
> my test machines for a week.  It's due to softlockup changes, and setting
> CONFIG_DETECT_SOFTLOCKUP=n "fixes" it.
>
> It sounds unlikely, but I'd suggest that you see if it's the same on your
> machine so we're not both chasing the same bug.

Unsetting CONFIG_DETECT_SOFTLOCKUP does not help in my case, but thanks for 
the suggestion.
