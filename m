Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbZA0S5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbZA0S5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbZA0S5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:57:32 -0500
Received: from outbound-mail-320.bluehost.com ([67.222.54.252]:36652 "HELO
	outbound-mail-320.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753844AbZA0S5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:57:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=I4/EGOcDw+7ZvBkmMIrM2UGL855T5OTSBpYu31rjggf6cm1HdUkD/H6AoL2YjdmDxMu5nOM4ZFJmlqJvgwZS0hUn2WetCWYPy76F5zQUmnqfA6i94atx4N5GeU9IegSJ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/2] PCI/MSI: Introduce pci_msix_table_size()
Date: Tue, 27 Jan 2009 10:57:29 -0800
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
References: <200901240019.36794.rjw@sisk.pl> <200901240021.14940.rjw@sisk.pl>
In-Reply-To: <200901240021.14940.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901271057.29348.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 23, 2009 3:21 pm Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Introduce new function pci_msix_table_size() returning the size of
> the MSI-X table of given PCI device or 0 if the device doesn't
> support MSI-X.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  drivers/pci/msi.c   |   24 +++++++++++++++++++-----
>  include/linux/pci.h |    5 +++++
>  2 files changed, 24 insertions(+), 5 deletions(-)

Ok, applied these two to my linux-next branch.  Thanks guys.

-- 
Jesse Barnes, Intel Open Source Technology Center
