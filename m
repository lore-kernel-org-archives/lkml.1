Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbXJaR0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbXJaR0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 13:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbXJaR0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 13:26:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:59404 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbXJaR0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 13:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BzFlVez6ZUsboZX65Kj9wFgqcM9obowebKXsfjGrKfvHXuU2NTtYB/IVx+ulUnlZjMm6mi0L/+qaWdUNQUayqSmx2OwjoNtGvfEFm8df9vihJDz1GlBULsDVGzl1JHjQnGS/5jPwOmbcQNr2NN1zvjAtaGLY/xvd9Z63XtClu2o=
Message-ID: <12c511ca0710311026v39a91e61o448b340f413e08c0@mail.gmail.com>
Date: Wed, 31 Oct 2007 10:26:37 -0700
From: "Tony Luck" <tony.luck@intel.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [PATCH 1/6] Driver core: remove class_device_*_bin_file
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1193807505-3821-1-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071031050954.GA3791@kroah.com>
	 <1193807505-3821-1-git-send-email-gregkh@suse.de>
X-Google-Sender-Auth: 430eb11663ebbb05
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/07, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> These functions are not used by anyone, so remove them from the tree.

/me coughs ...

  CC      drivers/pci/probe.o
drivers/pci/probe.c: In function `pci_create_legacy_files':
drivers/pci/probe.c:57: error: implicit declaration of function
`class_device_create_bin_file'
drivers/pci/probe.c: In function `pci_remove_legacy_files':
drivers/pci/probe.c:72: error: implicit declaration of function
`class_device_remove_bin_file'

-Tony
