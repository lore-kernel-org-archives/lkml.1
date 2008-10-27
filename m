Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYJ0Tve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYJ0Tve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbYJ0TvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:51:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:2004 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbYJ0TvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:51:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=YaH4z43QBaUZopdwolbbOM6klNShNmPvdz3iHJCxEsg8XE7vgUgelUGakMYiSzdn9h
         BbfccE833xeL4TT/3Ch2tAfE3ZgE9B7kzG4emSUkWUhsWN3fHhNc+jwlKZ9rYYZKf5K4
         sONXavNJODbgkYDl2sbUoVzc8oB1/3Wb5qyUc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] arm ide breakage
Date: Mon, 27 Oct 2008 19:38:53 +0100
User-Agent: KMail/1.9.10
Cc: Linus Torvalds <torvalds@linux-foundation.org>, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
References: <20081026054026.GO28946@ZenIV.linux.org.uk>
In-Reply-To: <20081026054026.GO28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810271938.53766.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 October 2008, Al Viro wrote:
> a) semicolon before the function body is a bad idea
> b) it's const struct foo, not struct const foo
> c) incidentally, it's ecard_remove_driver(), not ecard_unregister_driver()
> d) compiling is occasionally useful.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Thanks Al.
