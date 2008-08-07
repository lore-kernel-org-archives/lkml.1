Return-Path: <linux-kernel-owner+w=401wt.eu-S1757748AbYHGWea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748AbYHGWea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYHGWeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:34:19 -0400
Received: from outbound-mail-09.bluehost.com ([69.89.17.209]:59945 "HELO
	outbound-mail-09.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751568AbYHGWeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:34:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=FUbG5vHsAws8FNfnyk35/U3k1Wt+31px+nNr9wXIu4ZA/fkRMxCzcKYYqEYVv/5oxaFAsEKmgEg8WHhZm81on0BKuC28ZBYblNn7HohEg9c8jigrjBu1dwoCmRmn0kAJ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] PCI PM: Export pci_pme_active to drivers
Date: Thu, 7 Aug 2008 15:34:10 -0700
User-Agent: KMail/1.9.9
Cc: Alessandro Guido <alessandro.guido@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200808051730.27599.alessandro.guido@gmail.com> <200808080000.07156.rjw@sisk.pl> <200808080014.25493.rjw@sisk.pl>
In-Reply-To: <200808080014.25493.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808071534.11482.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 7, 2008 3:14 pm Rafael J. Wysocki wrote:
> PCI PM: Export pci_pme_active to drivers
>
> Export pci_pme_active() to drivers, so that they can clear the
> PME_status bit and disable PME# for their devices without involving
> ACPI.

Cool, applied.  Thanks Rafael.

Jesse
