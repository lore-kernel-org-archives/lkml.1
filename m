Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493Ab0AVAqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab0AVAqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 19:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221Ab0AVAqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 19:46:38 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:58886 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab0AVAqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 19:46:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=twtxEV4ZMzXRZekrrhbErmpTHjqqvdxngEBtYYZHbeIdYJngio26WkwsfJdtsCp6/1
         hYgJAHQS+9y8dqSZExoml15rp6d7pimPvCXcxWkk4RNmGidwQ+8f9VE0qLk2wcHeiE/C
         rRQ/zAIdYMDjcrzpwMf6pchNrn+uEgUUbO+20=
Message-ID: <4B58F5F6.9090001@gmail.com>
Date: Fri, 22 Jan 2010 09:48:54 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jgarzik@pobox.com, Reinhard.Tartler@informatik.uni-erlangen.de,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH #upstream-fixes] libata-sff: remove CONFIG_NO_ATA_LEGACY
References: <20100120142943.GE3580@faui49.informatik.uni-erlangen.de>	<4B579C4A.3040907@gmail.com> <20100121120405.1085b6d3@lxorguk.ukuu.org.uk>
In-Reply-To: <20100121120405.1085b6d3@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing David Howells, who BTW is on vacation till Feb) Hi!

On 01/21/2010 09:04 PM, Alan Cox wrote:
> On Thu, 21 Jan 2010 09:14:02 +0900
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> CONFIG_NO_ATA_LEGACY isn't used by anyone.  Drop it.
>>
>> Reported-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> Not unless this is cleared with the FRV maintainers who were using
> it and I believe may still need it.
> 
> Mr Howells ?

David, the patch in question is,

  http://lkml.org/lkml/2010/1/20/396

Does FRV still need it?

Thanks.

-- 
tejun
