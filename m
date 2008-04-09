Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbYDIPCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbYDIPCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 11:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYDIPCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 11:02:00 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:19823 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbYDIPB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:01:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fuXXkARFRdtHhPc9fKc11YbQLz+xn+I45nZRBC92MwetYV2C+X9XJN+G5kSBYkFpj1XZLlb3gnwzbkEBSoZM6mq10yN02UxHXb9UnVpfvL4vCInOgYAZL9LO2Y8/x6cHKJDHOSS8B/Os8Rw3i8/uq5OEtcFBS0aPd+R+IKyz4BY=
Message-ID: <2f11576a0804090801s49587b26h115e8e1760ec7671@mail.gmail.com>
Date: Thu, 10 Apr 2008 00:01:58 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Andreas Grimm" <agrimm61@gmail.com>
Subject: Re: VM - a plenty of inactive memory
Cc: "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com, kosaki.motohiro@gmail.com
In-Reply-To: <cf40c6a90804090657j7e76a84foeaf3c1c02d2a7b73@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cf40c6a90804090213u55491ceay9b211d75d74dc29c@mail.gmail.com>
	 <874pabrx6b.fsf@saeurebad.de>
	 <cf40c6a90804090657j7e76a84foeaf3c1c02d2a7b73@mail.gmail.com>
X-Google-Sender-Auth: 8d03640d87821a46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>  i know this. But why the kernel locks that memory for a so long time
>  (2 days now)?

maybe, page cache consume it.
it isn't mean that waste memory.

> Is there a way to enforce the reclaiming?

following command drop all cache. (but I don't reccomend it)

# echo 3 > /proc/sys/vm/drop_caches


>  And how can i
>  find out, which process owns that memory.

please use free command and see second line(+ buffer/cache'ed free mem).

>  The problem is, that i can't
>  accept, that the free memory fell down to 50MB, when i have 24GB in
>  the nirvana. The system was recently very close to the awkward
>  situation to swap to disk, and i bet it will do so in the next few
>  days, because it happened before. Unintelligible, if one got that much
>  ram.

may be, it is not happend forever.
