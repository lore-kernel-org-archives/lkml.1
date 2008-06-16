Return-Path: <linux-kernel-owner+w=401wt.eu-S1760267AbYFPHDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267AbYFPHDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbYFPHDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:03:37 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:35087 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759636AbYFPHDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:03:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:sender;
        b=isMC8BmIqs5xc5sQQ/FznoAhWXHSvnoahNaj+diY9UjxHDNqvt60pluhozgzL+pc4R
         zeF44vD0QQURMDKW4zP0AACr95dwdhQ4lqQcvG4Zc4+4ONYKVBt08WfSYc50lTAEZpIW
         62ycxZD1OFE6FB97KRKW1BWYr9nxdK2UFHigs=
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, sam@ravnborg.org
Subject: Re: [PATCH] export linux/a.out.h
References: <1213564021-5195-1-git-send-email-jacmet@sunsite.dk>
	<20080615153354.44b9d1b7@infradead.org>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Mon, 16 Jun 2008 09:03:29 +0200
In-Reply-To: <20080615153354.44b9d1b7@infradead.org> (Arjan van de Ven's message of "Sun\, 15 Jun 2008 15\:33\:54 -0700")
Message-ID: <87hcbtlv3y.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Arjan" == Arjan van de Ven <arjan@infradead.org> writes:

Hi,

 >> Export linux/a.out.h like we do for asm/a.out.h as some applications
 >> needs it (E.G. valgrind). 

 Arjan> do we know what they need it for?

>From a quick look at the valgrind code - struct nlist for stabs
parsing.

-- 
Bye, Peter Korsgaard
