Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbXCUPDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbXCUPDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbXCUPDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:03:51 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:43297 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbXCUPDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:03:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=LJ+RD9DqVF5PsIVGz1DkK2OtzG4MJ41BbcaAR1EDWHhjhNB78e5SdwB3oQ+PYa3JsleY4L5FF2XXYgRI4uS4k5kGBw+IyrNapWBhnSpkJItlV6Ma4jXmmn84DaACfJBs0WDk0pUzNk8ia1krSTwX9YTA6pgMeaM2ODCFuae2+L8=
Message-ID: <84144f020703210803x70c6827di99864618d36f725e@mail.gmail.com>
Date: Wed, 21 Mar 2007 17:03:48 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <christoph@lameter.com>
Subject: Re: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead of struct slab
Cc: "Eric Dumazet" <dada1@cosmosbay.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703210742080.1573@graphe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070321102231.7288f231.dada1@cosmosbay.com>
	 <84144f020703210521q10ad95d4g760010bd4388c71f@mail.gmail.com>
	 <Pine.LNX.4.64.0703210742080.1573@graphe.net>
X-Google-Sender-Auth: 1c283362aa6f31da
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/07, Christoph Lameter <christoph@lameter.com> wrote:
> None of that please. The page flags already contain a node number that is
> accessible via page_to_nid(). Just make sure that we never put a slab onto
> the wrong node.

Sounds good. Do you know for a fact that we don't or are you just
afraid we have a bug?
