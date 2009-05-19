Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbZESGEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbZESGEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 02:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZESGEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 02:04:48 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:51627 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZESGEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 02:04:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oZan1ylz7PQWuvjD+RtQwAi/LgC2xrk3sGr5I6ZtpGKBuNocdDqS3H98FSgADNRAaO
         YI9J8k3CKdxvqlZVZu80ONJrxySHQzRzoEBW4NRu3143RraAtQspiPZjRl1lun9oHIib
         YRlY8w68CqnzUwP1wguUpyNzJnSLgVNaZzGe4=
MIME-Version: 1.0
In-Reply-To: <20090518175745.da1f943f.randy.dunlap@oracle.com>
References: <20090518184225.d5721ac8.sfr@canb.auug.org.au>
	 <20090518175745.da1f943f.randy.dunlap@oracle.com>
Date: Tue, 19 May 2009 08:04:47 +0200
Message-ID: <71cd59b00905182304q4077b942o6ac41272e8306d90@mail.gmail.com>
Subject: Re: [PATCH -next] eeepc: fix kconfig selects
From: Corentin Chary <corentin.chary@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 2:57 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> EEEPC_LAPTOP selects HOTPLUG_PCI.  This causes failures (build error below)
> when CONFIG_HOTPLUG is not enabled, so additionally select HOTPLUG since
> kconfig 'select' doesn't follow its dependency chain.
> Also, only select HOTPLUG_PCI if PCI is already enabled.
>
> drivers/pci/hotplug/fakephp.c:55: error: implicit declaration of function 'pci_rescan_bus'

Acked-by: Corentin Chary <corentincj@iksaif.net>

Pushed into acpi4asus tree.
Len, please get it for rc7.

Thanks

-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
