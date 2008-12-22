Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYLVUyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYLVUyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 15:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYLVUxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 15:53:53 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:12988 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbYLVUxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 15:53:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Rv8N16n265pbPCFc54KnKKyglTpaH6/q/p23twGvjNVW5Egd8xPPVh469uCsIVWM7k
         K9mbIeEFkeVHlZ9g2kreaPcqwJg1gT3dWCwPlrRphxgD+zeuEZrRQgZZPBk/3iRJLhOi
         zDXIBqdi6DYd+KyhWTeRQEKkpNVap1wv0i+OQ=
Message-ID: <b6c5339f0812221253w5100d101uc1f9ffdf293e6916@mail.gmail.com>
Date: Mon, 22 Dec 2008 15:53:51 -0500
From: "Bob Copeland" <bcopeland@gmail.com>
To: "Soeren Sonnenburg" <kernel@nn7.de>
Subject: Re: ath5k_pci: gain calibration timeout / unable to reset hardware -11
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       ath5k-devel@venema.h4ckr.net
In-Reply-To: <1229923913.3886.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229923913.3886.7.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 12:31 AM, Soeren Sonnenburg <kernel@nn7.de> wrote:
> Hi,
>
> I was using the ath5k_pci driver on a macbook pro 1,1 and it is working
> for some time but then suddenly messages like the ones below appear and
> I have to *turn off* the machine to get it back working (even booting to
> osx is not sufficient - osx won't have network when things go wrong as
> they do after a couple of hours). Note that this happens with both
> 2.6.27 and .28.

Hi Soeren,

Thanks for the report.  It is a known problem, with a bugzilla entry already:

http://bugzilla.kernel.org/show_bug.cgi?id=12080

-- 
Bob Copeland %% www.bobcopeland.com
