Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbXLEHfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbXLEHfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbXLEHey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:34:54 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:8448 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbXLEHex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:34:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=q+gZvE/Q0Ijm9yFZAdGDj8LtxWoPbhUL7/gxPKFcCQZQJqsQkOEzw74HIstYlQPcQMifCunGs5rO1MJSPNESCpJ9ETzy6IpeAUmauyGmUpddIL/o0PYwg7FYsLAdQdnZAG9dPkj4Cdsyx1oLMqlXOCfcE/GmBrWSxNgxqobRO7U=
Message-ID: <47565486.8050701@gmail.com>
Date: Wed, 05 Dec 2007 16:34:30 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org, greg@kroah.com
Subject: Re: [PATCH] depmod: sort output according to modules.order
References: <47555AF1.8090304@gmail.com> <47555C64.8070607@gmail.com> <20071205072529.GA5681@uranus.ravnborg.org> <47565452.3010800@gmail.com>
In-Reply-To: <47565452.3010800@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> It would also simplify the kbuild integration if depmod
>> could read the modules as a space separated list where
>> duplicates are allowed.
>> If we do so then the is no reason to escape to the shell
>> in Makeilfe.build and we do not have to remove duplicates either.
> 
> I'm no Makefile expert so no doubt my modifications are ugly.  But I
> think producing a file w/ duplicates in it is just ugly.

Oh, and, depmod should do just fine with duplicate entries as it is.

-- 
tejun
