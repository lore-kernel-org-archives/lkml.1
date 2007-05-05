Return-Path: <linux-kernel-owner+w=401wt.eu-S933277AbXEEUIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277AbXEEUIE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933285AbXEEUIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:08:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:16330 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257AbXEEUIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=FZamv1gsKRvGl5EgQd0WoD/Ru7yj+eNnyhI/yt6WdWC0vkFB25h9qb4Xtjx7zS2YcDMYf1UHE46ZuV0Lh45EcrWrnhGL7hAgivqatBww5drjQ3p7YysjXl4LFF86jV/nA1my5VfiKrTeoYvMR/UYiXvTBoC+66ixBxP6MnW5eQU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH pata-2.6 fix queue] hpt366: don't check enablebits for HPT36x
Date: Sat, 5 May 2007 21:30:53 +0200
User-Agent: KMail/1.9.6
Cc: michal.kepien@poczta.onet.pl, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200705042318.37367.sshtylyov@ru.mvista.com>
In-Reply-To: <200705042318.37367.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705052130.53793.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2007, Sergei Shtylyov wrote:
> HPT36x chip don't seem to have the channel enable bits, so prevent the IDE core
> from checking them...
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

applied
