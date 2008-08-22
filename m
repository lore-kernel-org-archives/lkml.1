Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYHVTdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYHVTdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYHVTdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:33:11 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:31319 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYHVTdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:33:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=t/tM7pDe3H3Q63d7dMYxZNBj8F9o/4gZIcCM2anKCz2r1jZEbebEaS3eHE9h2Oo+Lw
         +WLL29JBRksI+iGTZmbBLXxx5He+uLMGxjwSA1Cm/7W1UWOcnvTFx9LIFeDlHUthiGaJ
         dQTaXak0z/6zeJFCGePgNSuEfzC2gTVDe1R38=
Message-ID: <56a8daef0808221233h68853587n6015ca7d809b17e1@mail.gmail.com>
Date: Fri, 22 Aug 2008 12:33:07 -0700
From: "John Ronciak" <john.ronciak@gmail.com>
To: "Ian Campbell" <ijc@hellion.org.uk>
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
Cc: "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Grant Coady" <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, bfields@fieldses.org, linux-nfs@vger.kernel.org,
       "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>,
       "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
       "Bruce Allan" <bruce.w.allan@intel.com>,
       "PJ Waskiewicz" <peter.p.waskiewicz.jr@intel.com>,
       "John Ronciak" <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net
In-Reply-To: <1219428818.27921.43.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <p6lha4te54h04qdbnos1mcemdmn1cfca6s@4ax.com>
	 <1219087258.7192.19.camel@localhost>
	 <1219400624.18774.67.camel@zakaz.uk.xensource.com>
	 <1219428489.6919.21.camel@localhost>
	 <1219428818.27921.43.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 11:13 AM, Ian Campbell <ijc@hellion.org.uk> wrote:

>> That's probably also a networking device driver issue candidate: your
>> RPC task is queued up waiting to be sent.
>>
>> What networking card+device driver are you using here?
>
> # ethtool -i eth0
> driver: e1000
> version: 7.3.20-k2-NAPI
> firmware-version: N/A
> bus-info: 0000:01:0a.0
There is nothing indicating that the NIC/driver is causing any sort of
problem here, at least not with what has been presented so far.  When
the NFS mount isn't working is the networking still active and
working?

-- 
Cheers,
John
