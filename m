Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbZHQTR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbZHQTR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 15:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbZHQTR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 15:17:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:35712 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbZHQTR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 15:17:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SGwI6KpTqupjDehPTT0VAfaxk1IkDwaHswqi/2biFP7YPjpMvYXfkrGsc94RP1HcuJ
         R+0CVjkmTpFv25RiKfTVKN3L3MwoQ7+ag6ZiS7JrLCHuTq8P/Mzo6dtGfIjsR7iH+Bmw
         DFF4nFeIQChrJaG9zXUWbgTSMLflR9apWGvWc=
Message-ID: <4A89AD04.2000808@gmail.com>
Date: Mon, 17 Aug 2009 12:18:28 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ohci1396_dma=early nogo on an imac?
References: <4A88F6BF.7090104@gmail.com> <4A89722A.1070407@s5r6.in-berlin.de> <dd18b0c30908171104o7ed67aa3x7cab741263de09c3@mail.gmail.com> <4A899D41.7000405@s5r6.in-berlin.de>
In-Reply-To: <4A899D41.7000405@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Justin Mattock wrote:
>> [  660.190134] ieee1394: Current remote IRM is not 1394a-2000
>> compliant, resetting...
> ...
>> keeps going.
>
> It's a bug in ieee1394.  http://bugzilla.kernel.org/show_bug.cgi?id=8403
>
> Use the ieee1394 disable_irm=1 parameter on one or both nodes.  
> Perhaps firescope will then get going as well.
Well I guess this is not going to work.
unable to use a boot param to initialize the dma=early option
plus if I'm able to do that, the system gets stuck before the modules
even activate.(man I got hosed...)

any other ideas on how to debug such a scenario?

Justin P. Mattock
