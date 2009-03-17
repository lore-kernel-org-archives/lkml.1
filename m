Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbZCQMoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbZCQMoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 08:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbZCQMn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 08:43:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:54830 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbZCQMn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 08:43:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pt43maGWbWx/Kwg0uuY0JyW/ebcozFGk9zg30krXSGVLMgK3ZtDCNJfyLGPuYM7HHE
         87+m/rYAFsZrQAcXZ9pXjWz0ZoLMHOrGPjIGVGn6i8wyH3xROkgWx2BlI4KfWs8rYIaJ
         IopytM8SWHaY85WiBQ5GEflFiU/nPwNLqK/Lk=
MIME-Version: 1.0
In-Reply-To: <20090317090322.GA24133@elf.ucw.cz>
References: <e9e614960903162141g2f272f82jee434fc6fc748544@mail.gmail.com>
	 <84144f020903162307x3d164432m4132b0dd1487bae@mail.gmail.com>
	 <20090317090322.GA24133@elf.ucw.cz>
Date: Tue, 17 Mar 2009 20:43:53 +0800
Message-ID: <e9e614960903170543p6117ce22qd0773d5a7cdd9977@mail.gmail.com>
Subject: Re: w35und driver unusable
From: luoyi <luoyi.ly@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wow,  thanks for your advice. and I can get it work now after I set my
wireless AP's channel to 1 and mode to "b/g auto".

3 problems:

1. it can only work with 802.11b mode

2. rmmod w35und
   modprobe w35und
   Kernel Panic

3. after it get IP address with dhcpcd, if I execute iwlist scan, then
it will lose the connection and never restore again, the only way make
it work again is to restart my computer.






2009/3/17 Pavel Machek <pavel@ucw.cz>:

>
> Winbond driver only supports channel 1, for now.
>                                                                        Pavel
