Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbXHUUku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbXHUUku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbXHUUki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:40:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:40605 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbXHUUkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:40:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=bNNDrMJzkhhDDE4KzdiO4AIPXCVDUOyl7KMfIX4eIV7ABIXNmDHR336sqE5WT5xPchkORPkdk2mdX9QG7mEcOXXbaQOEHADm9L3QLUZ50KZf7WHB/uAhsxTGmyLJwMG6fZhCmmHVT8RabMF12duTjn5wPLQ1g2z+/6c8QgNBPnE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 2/2] pdc202xx_new: switch to using pci_get_slot() (take 2)
Date: Tue, 21 Aug 2007 22:01:40 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200708191857.40309.sshtylyov@ru.mvista.com>
In-Reply-To: <200708191857.40309.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708212201.40883.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 August 2007, Sergei Shtylyov wrote:
> Switch to using pci_get_slot() in init_setup_pdc20270() to get to the mate chip
> behind DC21150 bridge as there's no need for the driver itself to walk the list
> of the PCI devices (and the driver didn't check the bus # of the found device).
> While at it, make it emit warning about IRQ # being fixed up (just like hpt366.c
> does) and "beautify" this whole function as well as init_setup_pdc20276()...
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

applied
