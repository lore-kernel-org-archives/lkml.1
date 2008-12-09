Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbYLIXO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbYLIXO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbYLIXOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:14:49 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:16196 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbYLIXOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:14:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=a0RO4LrDgVFQsp8/cXQswMNm/K+IRantVy9HvjFwbgSyk2We1Vj0LZGFe7M2WHbBQU
         5gTVMO2jg7vIUMC7X+J87A7ycOqhXYI0eGAGH85G/vHKX1xvQEHuo8YLZESrKsbfGo+t
         m2p4cApW9pS0ixfBHBYR4EFRFbHTTHOGwwM+0=
Subject: Re: byteorder headers on parisc
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
In-Reply-To: <20081209135714.GB7785@x200.localdomain>
References: <20081209185237.8bb715d7.sfr@canb.auug.org.au>
	 <20081209135714.GB7785@x200.localdomain>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 15:12:37 -0800
Message-Id: <1228864357.5480.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-09 at 16:57 +0300, Alexey Dobriyan wrote:
> May I politely ask how this was compiled-tested?

It wasn't.  I missed the usage of the internal __fswabXX on parisc,
Kyle already contected me yesterday about this and worked out
a fix.

Harvey

