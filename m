Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbZBBScj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbZBBScj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 13:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZBBSca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 13:32:30 -0500
Received: from outbound-mail-37.bluehost.com ([69.89.20.191]:51169 "HELO
	outbound-mail-37.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752775AbZBBSc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 13:32:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=uNJHCLw+SjCZKfyYDunxMk6FiwpW+5eKXCVHVziWhO7EjVvA9c65E5WN/LAGU//HaNbDW8wkj36qyXp/Ja25VcC70hV39Hvcxs/56YR4kg9pFR34OexS9ZgTELgXrGH+;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 0/3] PCI PM: More refinements of suspend-resume framework
Date: Mon, 2 Feb 2009 10:32:26 -0800
User-Agent: KMail/1.9.10
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200902012229.27517.rjw@sisk.pl>
In-Reply-To: <200902012229.27517.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902021032.26819.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 1, 2009 1:29 pm Rafael J. Wysocki wrote:
> Hi,
>
> After the recent discussion with Linus, I have the following three fixes of
> the PCI PM framework.
>
> The first patch fixes the bug that bridges (and PCIe ports) are disabled
> during suspend, althouth they shouldn't.
>
> The second one makes the PCI PM core handle devices more carefully (details
> in the changelog). [Note to Linus: devices are still put into low power
> states with interrupts on after this patch.  Moving that to the late
> suspend phase will be the next step.]
>
> The last patch makes the warning in pci_legacy_suspend() more useful.

Linus, do you want these as part of the next pull request?  If so, I'll check 
them out, pull them in, and let them run the linux-next build gauntlet for a 
day before sending them.  Otherwise I'll just send a pull request today with 
the 8 or so fixes I have queued now.

-- 
Jesse Barnes, Intel Open Source Technology Center
