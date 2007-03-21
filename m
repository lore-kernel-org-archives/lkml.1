Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbXCUNC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbXCUNC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 09:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbXCUNC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 09:02:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:50272 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbXCUNC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 09:02:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=C/hDAndsXmzmLJdBZbF8zuH4z7doknLyJA0Sp7oUZ6rhtAPl8hdhCs90u9bAXArYIWa/HvfKmKh2F/IVeZogHZklZvGOdXx120BYVIfsJBPKobsDup8ud0+0jS4JCAogKB2O+QF+4Hm6vskFR+1P6unTQOd7udP9G1CG6vI9r5g=
Message-ID: <84144f020703210602m53a6a76es774dd1c73b3cae7f@mail.gmail.com>
Date: Wed, 21 Mar 2007 15:02:25 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: [PATCH] SLAB : Use num_possible_cpus() in enable_cpucache()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <christoph@lameter.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <4600D756.7070500@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070320181235.77d28864.dada1@cosmosbay.com>
	 <Pine.LNX.4.64.0703201248530.12664@graphe.net>
	 <20070320213218.GA13952@one.firstfloor.org>
	 <46005B7D.3090701@cosmosbay.com>
	 <Pine.LNX.4.64.0703201715110.17799@graphe.net>
	 <4600D04B.6030305@cosmosbay.com> <4600D756.7070500@cosmosbay.com>
X-Google-Sender-Auth: d4a1c47da4b91b8e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> As most shiped linux kernels are now compiled with CONFIG_SMP, there is no way
> a preprocessor #if can detect if the machine is UP or SMP. Better to use
> num_possible_cpus().

Looks good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
