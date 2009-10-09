Return-Path: <linux-kernel-owner+w=401wt.eu-S964806AbZJIWeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806AbZJIWeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 18:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934708AbZJIWeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 18:34:02 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:61102 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934707AbZJIWeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 18:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=hTlb/LWPu/Hie7OlkltzvNl1iqTQ0rWK8M1pSIGDQ/dYFPIX4kymn5rVdiW9TLbMP7
         Co+gPPh65EPfopQP3FLfmCkqu8UB2wQHCV7ZpL4vopzI1WovTDd/c1jGh/53W+uF+Y69
         5dQq0+M6fU4X1At1t4Lv1LZpowU5MwP4MfJFs=
Message-ID: <4ACFBA31.1090602@gmail.com>
Date: Sat, 10 Oct 2009 00:33:21 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.7 Thunderbird/3.0b4
MIME-Version: 1.0
To: Richard Langly <richard.ringo.langly@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: printk() not outputting
References: <a3e829d20910091122p3c56acf6h975be820e555d400@mail.gmail.com>
In-Reply-To: <a3e829d20910091122p3c56acf6h975be820e555d400@mail.gmail.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2009 08:22 PM, Richard Langly wrote:
> So I changed the first value to 8, and I still don't see messages in
> my /var/log/messages file, nor using dmesg.

Well, if there is no other code than you posted, there's missing
module_init(my_init); line.
