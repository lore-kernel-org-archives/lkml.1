Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbXJISt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbXJISt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbXJIStB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:49:01 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:3998 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226AbXJISs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:48:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TQJrYxCpAqQTATuyKMSLA2tQ9V449o31OpiXoW32XqZxmt2SB7p8EjP7sU8vPUIzYQ+G02cWowPE+NuJruNGdzpq6L38t3lxBz+BgXjM5ojqDoTVlZpGiJm2wRXQlow6uh0cj9XlCcm0izqkHzgWLN4mBdQVuPUcDExavyBMH7k=
Message-ID: <84144f020710091148s6267a69aud18348af77f941b0@mail.gmail.com>
Date: Tue, 9 Oct 2007 21:48:58 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH -mm] slub: fix cpu hotplug offline/online path
Cc: "Akinobu Mita" <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0710091144020.32162@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071009161328.GA6470@APFDCB5C>
	 <Pine.LNX.4.64.0710091144020.32162@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: 1e8607910576c8ad
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On 10/9/07, Christoph Lameter <clameter@sgi.com> wrote:
> Could you check if a per cpu structure has already been allocated and then
> simply skip the call to init? Otherwise we end up with lots of per cpu
> structures for cpus that will never show up.

Does it matter? How?
