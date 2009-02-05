Return-Path: <linux-kernel-owner+w=401wt.eu-S1761658AbZBEBXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658AbZBEBXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbZBEBXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:23:43 -0500
Received: from outbound-mail-145.bluehost.com ([67.222.38.35]:55215 "HELO
	outbound-mail-145.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755544AbZBEBXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:23:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=o4rYWxIEVvJIjozKHMxM4/upeGEZ7tH7Vd1KWiO549L8QL7+Xa20mS2P1wauzquo1eD/ab/zatbb9gviyg15JigZKj4T2S+iiPxrMmy4nnVPjTHAWk+o5Lmg5bqUf4ZD;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 0/7] PCI PM: Fixes and refinements
Date: Wed, 4 Feb 2009 17:23:38 -0800
User-Agent: KMail/1.9.10
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200902040154.36018.rjw@sisk.pl>
In-Reply-To: <200902040154.36018.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041723.39209.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 3, 2009 4:54 pm Rafael J. Wysocki wrote:
> Hi,
>
> The following series of patches contains some fixes and refinements of the
> PCI PM framework.
>
> [1/7] fixes the problem that some driverless devices don't like to be power
> managed and break things if we attempt to do it.
>
> [2/7] and [3/7] fix the problem with devices in PCI_UNKNOWN that are
> mishandled by the new code.
>
> [4/7] fixes regression related to PCIe port suspend-resume.
>
> [5/7] fixes the bug that bridges (and PCIe ports) are disabled during
> suspend, althouth they shouldn't be.
>
> [6/7] makes pci_restore_standard_config() read the current power state of
> the device from the device itself after attempting to change it.
>
> [7/7] makes the PCI PM core handle devices more carefully (details in the
> changelog).
>
> Please disregard any previous versions of these patches I sent to you.

Ok, I pushed this series into my for-linus branch.  Aside from the minor 
issues in 7/7 that I already mentioned on irc things looked fine, and those 
were really just cleanups anyway.

-- 
Jesse Barnes, Intel Open Source Technology Center
