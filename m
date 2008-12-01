Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbYLAUa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbYLAUa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 15:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbYLAUav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 15:30:51 -0500
Received: from outbound-mail-119.bluehost.com ([69.89.22.19]:58772 "HELO
	outbound-mail-119.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752133AbYLAUav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 15:30:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=ZEWE6YoVcUi5M+lZoACOsrwb6DAFQbQ3bD1vynVRcIg+2XDLdWplSYEh+0jsQD94R8wUcaLnU44aHjW+kpXoXCwVNOUvPeX3ERTt03aOzAyAmvsTFfc7TE2XKUf1Jdxk;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 2/2] drivers/pci/hotplug: Add missing pci_dev_get
Date: Mon, 1 Dec 2008 12:30:49 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0811230907370.28343@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0811230907370.28343@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011230.49406.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 23, 2008 12:08 am Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>
> pci_get_slot does a pci_dev_get, so pci_dev_put needs to be called in an
> error case.
>
> An alterative would be to move the test_and_set_bit before the call to
> pci_get_slot.
>
> The problem was fixed using the following semantic patch.
> (http://www.emn.fr/x-info/coccinelle/)

Applied to my linux-next branch, thanks.  Btw, I've seen quite a few of these 
Coccinelle related patches fly by, but I haven't seen an introduction of the 
tool posted to lkml.  Did I miss it?  Or maybe it just went to the janitors 
list?  If not, it seems like it might be a worthwhile thing to describe for 
people...


-- 
Jesse Barnes, Intel Open Source Technology Center

