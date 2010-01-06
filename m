Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387Ab0AFWGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab0AFWGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932832Ab0AFWGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:06:13 -0500
Received: from outbound-mail-29.bluehost.com ([69.89.17.211]:57024 "HELO
	outbound-mail-29.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756265Ab0AFWGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:06:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ZKS4Q3Wg14MUptqayGM83S3Xf/hWabPmDmLdv/3w/rx5vD3KfqBd3bboVRBNSIMN91PNziVd9a+i0WmuVnAvWoM2msjMu8md6iRMfRHshznXmgOUvLjJIEr9SI99DD6y;
Date: Wed, 6 Jan 2010 14:06:06 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: [PATCH 11/12] PCI PM: Run-time callbacks for PCI bus type (rev.
 2)
Message-ID: <20100106140606.0bd3e4fd@jbarnes-piketon>
In-Reply-To: <200912272108.25145.rjw@sisk.pl>
References: <200912272057.10443.rjw@sisk.pl>
	<200912272108.25145.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Dec 2009 21:08:24 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Introduce run-time PM callbacks for the PCI bus type.  Make the new
> callbacks work in analogy with the existing system sleep PM
> callbacks, so that the drivers already converted to struct dev_pm_ops
> can use their suspend and resume routines for run-time PM without
> modifications.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---

Looks good.

-- 
Jesse Barnes, Intel Open Source Technology Center
