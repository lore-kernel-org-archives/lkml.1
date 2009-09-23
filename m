Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbZIWSfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbZIWSfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 14:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZIWSfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 14:35:38 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:51264 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbZIWSfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 14:35:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ee+bMs6DGh1obzrAZABQVLke3Aqk6bamNmID7liqrP69xvhrxM664WAZQKJmCNSU7h
         h1rWDCxr4yV5p3IshHxW5JaukAp3rCylsXZO0vw4sx+76GHFOkVDk3wjoaLIsrc01XRz
         SZ/0lSaD9hztzqzJ9+BI+TJmcKTh81BO6M2j4=
Message-ID: <4ABA6A90.4000501@tuffmail.co.uk>
Date: Wed, 23 Sep 2009 19:36:00 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, linux-modules@vger.org
Subject: Re: [PATCH 3/4] module: unexport each_symbol()
References: <1253626718-18887-1-git-send-email-alan-jenkins@tuffmail.co.uk> <1253626718-18887-4-git-send-email-alan-jenkins@tuffmail.co.uk> <alpine.DEB.1.10.0909231112490.15822@dr-wily.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0909231112490.15822@dr-wily.mit.edu>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott wrote:
> Hi Alan,
>
> I really like what you're doing with this patch series; using a binary 
> search for the symbol table has been something I've wanted to do in the 
> kernel's module loader ever since I optimized Ksplice's symbol resolution 
> code to use binary rather than linear searches.
>
> While Ksplice is not in-tree yet, Ksplice is a user of each_symbol (and in 
> fact was the reason why each_symbol was originally exported).  Is it easy 
> to modify your patch series so that you don't have to remove each_symbol?
>   

I'll have to think harder about it, but that's my problem. I should have 
checked the changelog :-).

Regards
Alan
