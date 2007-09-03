Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbXICL4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbXICL4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 07:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbXICL4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 07:56:10 -0400
Received: from mail.op5.se ([193.201.96.20]:47932 "EHLO mail.op5.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbXICL4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 07:56:09 -0400
X-Greylist: delayed 1435 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Sep 2007 07:56:09 EDT
X-Spam-Score: -4.399
Message-ID: <46DBF0BB.3070605@op5.se>
Date: Mon, 03 Sep 2007 13:32:11 +0200
From: Andreas Ericsson <ae@op5.se>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>
CC: Sean <seanlkml@sympatico.ca>, "H. Peter Anvin" <hpa@zytor.com>,
       David Kastrup <dak@gnu.org>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.3
References: <7vodglr32i.fsf@gitster.siamese.dyndns.org>	<46DA5F33.2020005@zytor.com> <85odgltrtj.fsf@lola.goethe.zz>	<46DA88EF.7080103@zytor.com>	<20070902133803.1b46f599.seanlkml@sympatico.ca> <7v4picpvgq.fsf@gitster.siamese.dyndns.org>
In-Reply-To: <7v4picpvgq.fsf@gitster.siamese.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano wrote:
> 
> Assuming that we do not give the old git-p4import script
> packaged in "git-p4 package", would the following patch be all
> that is needed, or do we need other things in the spec file?
> 
> -- snipsnap clipcrap --
> +Obsoletes:	git-p4

That depends. If packages outside of git requires the git-p4 package to function
then this will not suffice and a line saying

	Provides: git-p4

would have to be added instead. If some other already installed package Require:'s
/usr/bin/git-p4import, then that other package is broken and we're toast.

I have a hard time seeing what other package would depend on the git-p4import
script so this was more along the lines of "how rpm dependencies work, kinda"
than a real issue.

-- 
Andreas Ericsson                   andreas.ericsson@op5.se
OP5 AB                             www.op5.se
Tel: +46 8-230225                  Fax: +46 8-230231
