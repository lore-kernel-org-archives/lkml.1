Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbYHRUs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbYHRUs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbYHRUsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:48:45 -0400
Received: from outbound-mail-128.bluehost.com ([67.222.38.28]:44625 "HELO
	outbound-mail-128.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753776AbYHRUso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:48:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=dgFQoW70ZsRZ7UYCe285lwHtoKzh5qdQhDM1YzEBigg/UGjIaKAUE/27QE5at51xdwzjNGgr4LM3II1BwJwB3LO0x6d6N5xMVUw9472FKiepAMaFkpMliu1Qp7RsJiLD;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] PCI: acpi_pcihp, run _OSC on a root bridge
Date: Mon, 18 Aug 2008 13:48:39 -0700
User-Agent: KMail/1.9.9
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kristen.c.accardi@intel.com
References: <1218469660-24230-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1218469660-24230-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181348.39992.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 11, 2008 8:47 am Jiri Slaby wrote:
> _OSC should be ran on a root bridge instead of the device itself.
> Do this before touching OSHP since PCI fw specs states that _OSC
> should be preferred over OSHP (however if the device has OSHP but
> not _OSC -- not a root bridge -- it's not).
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: kristen.c.accardi@intel.com
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>

Thanks Jiri, I applied both of these to my for-linus branch.
-- 
Jesse Barnes, Intel Open Source Technology Center
