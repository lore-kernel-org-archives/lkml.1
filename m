Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471Ab0AJOLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab0AJOLQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 09:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309Ab0AJOLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 09:11:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:56779 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab0AJOLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 09:11:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mzutDexBSpVNh99YTw5SQwjBHSuNASv+rCK3KisttzVF001tGnJLHoP40qHJHKUq1e
         3OTBPACviugWbyL7H7vTnWRykhF/jVtVn4w75kFS6l+3mq2Lejy4RrSpSxmtvzHU37MY
         XlFKfHXBXjHtaeHH3TZmiKsfF8h00FHRYDikI=
Date: Sun, 10 Jan 2010 16:11:06 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: nm127@freemail.hu
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] block: make PCI device id constant
Message-ID: <20100110141106.GA4293@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -static struct pci_device_id DAC960_id_table[] = {
> +static const struct pci_device_id DAC960_id_table[] = {

NAK, we have DEFINE_PCI_DEVICE_TABLE()
