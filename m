Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbZLCWWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbZLCWWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZLCWWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:22:37 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:56714 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZLCWWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:22:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KFlyY9qZtNmXJIw2gPK/aClfTZvepfVD00OZFYWC4UCbVA9Fagw0TSdsBblPWsQLuP
         bq5tk0hgfO/GuEIgLHgyd1OjaK1Sapsdl6JzIM/2aTnFclKBEYnS+zmdeh+4KiipW3MH
         WHBYGJyFAhIB8zqRZwgueZzo8frPMpi+vbQNk=
Message-ID: <4B183A2E.5080402@garzik.org>
Date: Thu, 03 Dec 2009 17:22:38 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912032256.39790.bzolnier@gmail.com> <4B18357C.8070807@garzik.org> <200912032306.52022.bzolnier@gmail.com> <4B18376B.3080404@garzik.org>
In-Reply-To: <4B18376B.3080404@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2009 05:10 PM, Jeff Garzik wrote:
> Did the patch contain -cosmetic- changes intermingled with code changes,
> in the same code lines? No.
>
> Is it good kernel practice to intermingle cosmetic changes with
> functional ones, in the same code lines? Also, no.


In fact, I recall one case where a certain developer on this list used 
cosmetic code changes (Lindent, IIRC) to hide functional, 
security-related code changes.

Mixing cosmetic and function changes is simply bad engineering practice, 
_especially_ when they occur in the same lines of code.

	Jeff



