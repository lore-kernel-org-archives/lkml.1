Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbZBMVP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbZBMVP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 16:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbZBMVPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 16:15:49 -0500
Received: from outbound-mail-305.bluehost.com ([67.222.53.251]:33219 "HELO
	outbound-mail-305.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753010AbZBMVPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 16:15:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=RIUqzNlWKHzy0v4JI6JBj1wOu5ClNBw0Qm6by8VVzYgsvJWhDtCpKEk1TU1mFgkTr/RaPNARbPuk1p6DNamw+XU1aq98LQqCx0oc+NXhEND1oyCwSK/zhuMUmM3SP+7w;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] PCI: enhance physical slot debug information
Date: Fri, 13 Feb 2009 13:15:46 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Patterson <andrew.patterson@hp.com>, linux-pci@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20090204182522.GA22419@ldl.fc.hp.com>
In-Reply-To: <20090204182522.GA22419@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131315.46982.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 4, 2009 10:25 am Alex Chiang wrote:
> Convert usages of pr_debug to dev_dbg and add physical slot name.
>
> Note that we use dev_dbg on the struct pci_bus and still manually
> print out the PCI slot number (instead of calling dev_dbg on a
> pci_dev) because a struct pci_bus with empty physical slots will
> not have any pci_devs.
>
> Reviewed-by: Andrew Patterson <andrew.patterson@hp.com>
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> Jesse, since this is all under #ifdef DEBUG, it's your call
> whether you want to queue it for .29 or .30. Doesn't matter much
> to us either way, thanks.

Just applied this to my linux-next branch.  Thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
