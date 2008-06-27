Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbYF0P5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbYF0P5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 11:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYF0P47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 11:56:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:59143 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYF0P47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 11:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tF9+00wdGIXOn3BeuiqNkfgVhFoAFe6+3BwDAtBg8uj4tvRa+JMZn+gEicJ7Fj2ebF
         jwkluazaZtiH++rRylBxrffYvZMQTzeZqFAGk/CVdnXAojsNJkoqo9k3yYTa61dQMAQg
         c5SnJZzAeuixwWEoinIyTBKuVCk1TWDhLBnEM=
Message-ID: <8bd0f97a0806270856n777b900icb3dca9d99420394@mail.gmail.com>
Date: Fri, 27 Jun 2008 11:56:58 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jonathan Corbet" <corbet@lwn.net>
Subject: Re: The state of the BKL-removal tree
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arnd Bergmann" <arnd@arndb.de>, "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <20080627095418.2353267d@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080627095418.2353267d@bike.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 11:54 AM, Jonathan Corbet wrote:
> This tree has been in linux-next since mid-May.  In the absence of
> reasons to the contrary, my intent is to ask for this to be merged for
> 2.6.27.  Objections, anybody?

i see this still has this unnecessary hunk:
>      bf561-coreb: BKL pushdown
>  arch/blackfin/mach-bf561/coreb.c             |    4 ++
-mike
