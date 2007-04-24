Return-Path: <linux-kernel-owner+w=401wt.eu-S1161544AbXDXCzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161544AbXDXCzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 22:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161548AbXDXCzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 22:55:36 -0400
Received: from web36706.mail.mud.yahoo.com ([209.191.85.40]:35919 "HELO
	web36706.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161544AbXDXCzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 22:55:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=fOGAxHbbYtBpOhV7NA5Ilnbr3XpXAsfeudjpVjwWCsLRWS22iwFsN4yA354s+XePf9ZDk2nPicsNek6iqrs68tGVT/HWUIef1PbNYQZZvvWt+0QHrM54kl2zQcJX3LkfTFBCpobFPTrD49GyBGGOs1nR9qYegmZ3kPKPRR7kW8o=;
X-YMail-OSG: os2cjSYVM1nfvpRs0kNy9i4btBSzmQszfF1c7zgQd.nEmcnmFI1oebp2wC8FWjli.3CPnzv8DbHJe2xXAzyyKD8ZDPu0prc29iEGTycfPBwQPac7msJMc1Z6xCWs4g--
Date: Mon, 23 Apr 2007 19:55:34 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
To: Sergey Yanovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <5a04609e0704230712i1d4aeeb8ke9d8649e167eebe9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <86245.21997.qm@web36706.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I am not in any way argue that your driver architecture is wrong or that you
> should change anything. My point was simple. [tifm_sd] can only work with
> [tifm_7xx1]. If you add support for let's say [tifm_8xx2] in the future, which
> would have port offsets different that [tifm_7xx1], you would also need a
> completely new modules for slots (sd, ms, etc).
> 

Does not this constitutes an unbounded speculation? And then, what would you propose to do with
adapters that have SD support disabled? There are quite a few of those in the wild, as of right
now (SD support is provided by bundled SDHCI on such systems, if at all). Similar argument goes
for other media types as well - many controllers have xD support disabled too (I think you have
one of those - Sony really values its customers). After all, it is not healthy to have dead code
in the kernel.

On the other hand, if TI puts out a controller which is functionally identical, but has different
register map, it wouldn't be hard to refactor the code. 


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
