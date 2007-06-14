Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbXFNOKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbXFNOKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 10:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbXFNOKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 10:10:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:51071 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXFNOKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 10:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VtwD35LdFUEmfFRewt0Fl0ucKf/5gEJL+1qg3lrFUc8MM88xyzaUTCSgA5hG6gmUq/HShTW1Di/ZDCptvq1pwo/bTSpscAZQt6hVIgnUcYxWB6jnogIdWhMxQsaIPtkX7lapeQxY6qR8dAxsWnNSkNPkgO048Gr4oupZCHWHTDs=
Message-ID: <e85b9d30706140710x5671fa12n5845172d4ce32a10@mail.gmail.com>
Date: Thu, 14 Jun 2007 16:10:44 +0200
From: Matthew <jackdachef@gmail.com>
To: "Paolo Ornati" <ornati@fastwebnet.it>
Subject: Re: /dev/loop* devices not appearing in /dev (at least since 2.6.22-rc3*)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070614145206.58fdec91@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e85b9d30706140437s5f3622c3rc86c75a4f845e7a3@mail.gmail.com>
	 <20070614145206.58fdec91@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Paolo, Markus,

I just tried out

modprobe loop max_loop=32

output of dmesg is:

[  457.607575] loop: the max_loop option is obsolete and will be
removed in March 2008
[  457.607578] loop: module loaded

but there are NO loop devices in /dev:

ls -l /dev/ | grep loop
still shows nothing, strange ...

so I'll stick to .22-rc4 with that patch (works, as far as creation of
loop devices are concerned)

Regards
