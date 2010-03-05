Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0CEJ3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 04:29:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:28890 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab0CEJ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 04:29:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FYrFFvib/gbcYZqgq2LaZV0JDDVRF3KdZI5cVCvPgV2BBNzChjr2xj7EEco+SGyVv1
         1NJg7aVvY4t8ygtJ60U9aQyFgMWZePT59HerniHDORR+29W7nGJtDSfTUhhM0azlqanE
         v6oILUWh7VvokmfUjOOlADkdj4232FbDW7nHA=
Message-ID: <4B90CEDD.6020106@gmail.com>
Date: Fri, 05 Mar 2010 10:29:01 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-11.2 Thunderbird/3.0.1
MIME-Version: 1.0
To: Johannes Sixt <j.sixt@viscovery.net>
CC: git@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: gitignore broken in git 1.7.0.1: slash checks leading dirs
References: <4B90C701.3070308@gmail.com> <4B90C974.2050405@viscovery.net> <4B90C9BE.1030407@gmail.com> <4B90CBE5.9090102@viscovery.net>
In-Reply-To: <4B90CBE5.9090102@viscovery.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2010 10:16 AM, Johannes Sixt wrote:
> The cited sentence says that the particular check considers only the last
> path component of the pathname.

Thinking about it, there is no way to specify a *filename* no matter
where it lies? I.e. patterns such as *.o matches also a/b/test.o/test.c?
Am I missing something?

-- 
js
