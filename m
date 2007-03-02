Return-Path: <linux-kernel-owner+w=401wt.eu-S2992522AbXCBPcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992522AbXCBPcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 10:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992524AbXCBPcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 10:32:12 -0500
Received: from smtp.bulldogdsl.com ([212.158.248.8]:3159 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992522AbXCBPcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 10:32:11 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata Kconfig: Update the various experimentality levels
Date: Fri, 2 Mar 2007 15:32:01 +0000
User-Agent: KMail/1.9.5
Cc: jgarzik@pobox.com, akpm@osdl.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20070302150512.281af8d3@lxorguk.ukuu.org.uk>
In-Reply-To: <20070302150512.281af8d3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703021532.02215.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 March 2007 15:05, you wrote:
> Signed-off-by: Alan Cox <alan@redhat.com>
[snip]
>  config PATA_OLDPIIX
> -	tristate "Intel PATA old PIIX support (Experimental)"
> +	tristate "Intel PATA support for the original PIIX"
>  	depends on PCI && EXPERIMENTAL
>  	help
> -	  This option enables support for old(?) PIIX PATA support.
> +	  This option enables support for early Intel PIIX PATA support.

Probably nothing, but is it intentional to remove the "(Experimental)" text 
here, but not the dependency on EXPERIMENTAL?

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
