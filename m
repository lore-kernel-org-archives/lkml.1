Return-Path: <linux-kernel-owner+w=401wt.eu-S933620AbYBNMQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620AbYBNMQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759455AbYBNMPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:15:07 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:14652 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758840AbYBNMO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:14:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=PhKHjp/I6kimFurJT5lzAmlnjXflzi3qsE3Vsm0ZRevpc7ZAqtFV4wjNqu0L2JwwEv4XxoO6YLdjPmjHgY5dHVPWGuJqSRn+N/3yIQxGweSx+K/Dyh4HvSbQfJ6yGMeIU9tldUi7Fu1ixPzBkdRsRcSN1fOiDzzYkfFQ1aE88Y8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andreas Jaeger <aj@suse.de>
Subject: Re: [discuss] pci_get_device_reverse(), why does Calgary need this?
Date: Thu, 14 Feb 2008 13:11:42 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Greg KH <greg@kroah.com>, muli@il.ibm.com, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jdmason@kudzu.us, linux-pci@atrey.karlin.mff.cuni.cz,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20080213001506.GA13933@kroah.com> <20080213181655.GB8960@kroah.com> <ho3arwq8w7.fsf@reger.suse.de>
In-Reply-To: <ho3arwq8w7.fsf@reger.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802141311.43103.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008, Andreas Jaeger wrote:
> Greg KH <greg@kroah.com> writes:
> 
> > How does the patch below look?  I didn't want to remove the whole config
> > option, as there is more to the logic than just the "reverse order"
> > stuff there.
> 
> I think you miss Documentation - it's mentioned in ide.txt and
> kernel-parameters.txt,

+ drivers/ide/Kconfig

Greg, please update the patch (and add my S-o-B while at it).

Thanks,
Bart
