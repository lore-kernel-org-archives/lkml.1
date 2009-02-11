Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbZBKPtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbZBKPtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbZBKPtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:49:05 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:11388 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbZBKPtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:49:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QTk/MR8X4SJW0KZ+nTU4AfgSnwbekuz/1WHRylCLrU/wEzvrZFM1y2musY2CAsBoi/
         tjEJWUHYh2087f8yXzqZHXc/AbXnjzzExnhhh+Wcmx4QPNlNunIwjre8I1eWBGVZidFR
         frGuvB+pap2i0EMmDcJSntHrf72w4aQd/rD/M=
Subject: Re: get/put unaligned helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090211143521.GA18866@lst.de>
References: <20090211143521.GA18866@lst.de>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 07:48:58 -0800
Message-Id: <1234367339.5481.3.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-11 at 15:35 +0100, Christoph Hellwig wrote:
> I just loked into using the new get/put unaligned helpers.  I must
> say that I'm really unhappy about the lack of typing there.  We did
> put all the sparse infrastructure in place to make sure we do have
> strong typechecking for LE/Be types, but using these helpers defeats
> that.
> 
> Can you please make these properly typed?

Sorry, real life got in the way, I had a series in -mm for a few months
that did the typing and fixed the argument ordering by providing a
load/store API and then moving the existing users across, but that got
delayed while the (aligned) byteswapping patches were made suitable
for mainline.

I'll get that series revived shortly.

Harvey

