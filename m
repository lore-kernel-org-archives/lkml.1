Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbXLXVAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbXLXVAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 16:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbXLXU7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 15:59:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:51947 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbXLXU7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 15:59:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=W7Ms6fmVoyPHECDl3gMUxHFqniXLXwt1q9/y5oiO1czyj1YWS/C0o4IKiLVlkNOm/6GQzcyXQ7rYxPfs8mEj7cE7kL+pHwMtAUjW2MU/r1XBdMruYIKxaD1hTuq9ttkS8+nqFZP72hpZn7C5CrB2RelfsKQh+RDh6q6oScWZAeQ=
Message-ID: <84144f020712241259o27f4015ai1128fbb675d079ef@mail.gmail.com>
Date: Mon, 24 Dec 2007 22:59:53 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH] slub: /proc/slabinfo ABI compatibility
Cc: "Ingo Molnar" <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, andi@firstfloor.org,
       a.p.zijlstra@chello.nl
In-Reply-To: <Pine.LNX.4.64.0712241110240.8802@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0712221446280.24655@sbz-30.cs.Helsinki.FI>
	 <20071222131601.GB32558@elte.hu> <20071222133727.GA12031@elte.hu>
	 <Pine.LNX.4.64.0712241110240.8802@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: 74e949cbd97ec1fd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 24, 2007 9:12 PM, Christoph Lameter <clameter@sgi.com> wrote:
> Hmmm... What is the combination of config variables that causes this? I
> moved the count_partial function in mm in order to make the merge of slab
> defrag easier.

I think it's CONFIG_PROC_FS without CONFIG_SYSFS.
