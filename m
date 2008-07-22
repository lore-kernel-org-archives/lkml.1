Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbYGVSUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbYGVSUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYGVSUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:20:22 -0400
Received: from outbound-mail-141.bluehost.com ([67.222.38.31]:36080 "HELO
	outbound-mail-141.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751268AbYGVSUV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:20:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=mLS5ES0F1ZPdFrNjNq6rmdh0bIVVlioJHhtaO2A8Rjzqf20visihsNpfdVmrntlpDRbx3LT9xFiMfDf0g9aRQYr/mWLaM5o3z+FKJ0d6q6LQTYlkZfIONLtOB/IBYavN;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] PCI: hotplug: fix error path in pci_slot's register_slot
Date: Tue, 22 Jul 2008 11:20:13 -0700
User-Agent: KMail/1.9.9
Cc: juha_motorsportcom@luukku.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20080717171332.GD24683@ldl.fc.hp.com>
In-Reply-To: <20080717171332.GD24683@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807221120.13424.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 17, 2008 10:13 am Alex Chiang wrote:
> Juha Leppänen noticed that an error path in register_slot()
> wasn't returning appropriately, leading to a condition where we
> might access a kfree'ed pointer, so let's fix that.
>
> Additionally, fix up the copyright information in the file while
> we're in there.
>
> Signed-off-by: Alex Chiang <achiang@hp.com>

Thanks Alex & Juha, I've applied this to my for-linus tree.

Jesse
