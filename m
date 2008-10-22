Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbYJVWqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbYJVWqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbYJVWps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:45:48 -0400
Received: from outbound-mail-129.bluehost.com ([67.222.38.29]:41125 "HELO
	outbound-mail-129.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754868AbYJVWpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:45:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=MQHtsDTb1dieYfXM4g06OZ3GHEF4lwtystzhypkfZZ4R6unURcpfKf1tQSfHZtJiUfv19OtcQcBqA88nFImET794jJrEi9wdHvB3zEIEunNcjoSqPO34iZEnBNT8id8d;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] pci: PCI_QUIRKS depends on PCI
Date: Wed, 22 Oct 2008 15:45:42 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Thomas Petazzoni <thomas.petazzoni@enix.org>, linux-pci@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0810220851440.8356@anakin>
In-Reply-To: <Pine.LNX.4.64.0810220851440.8356@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810221545.42408.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 21, 2008 11:53 pm Geert Uytterhoeven wrote:
> commit 3d137310245e4cdc3e8c8ba1bea2e145a87ae8e3 ("PCI: allow quirks to be
> compiled out") introduced CONFIG_PCI_QUIRKS, which now shows up in each
> and every .config.
>
> Probably the intention was to make the PCI_QUIRKS symbol depend on PCI, not
> on its selection enabler?
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Yeah, that works.  Thanks Geert.

Jesse
