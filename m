Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbYLKSuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbYLKSuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 13:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbYLKStx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 13:49:53 -0500
Received: from outbound-mail-306.bluehost.com ([67.222.53.252]:42116 "HELO
	outbound-mail-306.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754068AbYLKStx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 13:49:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=dQbQZp2RHg/2TQfGeSL6WRuOS0lBV8FGtjv7lZ4zc/Elyg4kzm/hAZ810nKfyr+Bt3Y8SZ5k/oXlC+FBYhfmFQ/xAwauS/ic9N2n9XhyXtdwrEC7pjYHAYSDu5RchKyE;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH 1/2] PCI Hotplug: acpiphp wants a 64-bit _SUN
Date: Thu, 11 Dec 2008 10:35:01 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: justin.chen@hp.com, "linux-pci" <linux-pci@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20081211181242.GD18309@ldl.fc.hp.com> <20081211181644.GE18309@ldl.fc.hp.com>
In-Reply-To: <20081211181644.GE18309@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812111035.02652.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 216.239.45.19 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 11, 2008 10:16 am Alex Chiang wrote:
> From: Justin Chen <justin.chen@hp.com>
>
> Certain HP machines require the full 64 bits of _SUN as allowed
> by the ACPI spec. Without this change, we get name collisions in
> the lower 32 bits of the _SUN returned by firmware.
>
> Signed-off-by: Justin Chen <justin.chen@hp.com>
> Signed-off-by: Alex Chiang <achiang@hp.com>

It's very late in the cycle, so I'd like to get acks from at least a couple of 
other testers for this one...  Any volunteers?

Thanks,
Jesse
