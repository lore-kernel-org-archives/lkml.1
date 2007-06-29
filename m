Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbXF2WBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbXF2WBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 18:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbXF2WBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 18:01:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:42457 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbXF2WBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 18:01:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=YdtNT0w/DkHa5huyxpLovCiQfRNF1fMgn8OY7myvyKAeXZUN9e7OnY2zl0FffepZfQI7HXsn/ioqGrfda+h+MHaDCmmQLvZfOb9WsIwj1cxPkai5JsvqPvc92Z1pwydNASXyjjdlF12EGgqVaBS6G6B2aYqh7aO9z37vdmwYZqM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH pata-2.6 fix] hpt366: use correct enablebits for HPT36x
Date: Fri, 29 Jun 2007 23:06:59 +0200
User-Agent: KMail/1.9.6
Cc: michal.kepien@poczta.onet.pl, linas@austin.ibm.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200706300004.22274.sshtylyov@ru.mvista.com>
In-Reply-To: <200706300004.22274.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706292306.59194.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 June 2007, Sergei Shtylyov wrote:
> The HPT36x chips finally turned out to have the channel enable bits -- however,
> badly implemented.  Make use of them despite it's probably only going to burden
> the driver's code -- assuming both channels are always enabled by the HighPoint
> BIOS anyway...
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

applied
