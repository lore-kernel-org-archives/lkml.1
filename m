Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYKHOSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYKHOSx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 09:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYKHOSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 09:18:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:27490 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbYKHOSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 09:18:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=PzwhC1jjRicJJ/www+hvoOV0E/kv3uayqaZCaL87F3Jrmg/e+LzUexNSx1eLzkJweM
         gntoMSHFVYb1QBDbHCGB0VqR7xNIaq6yGU9mGqV5OdoZ9tE8BAUfDyE87wYhE8cqg5Vf
         dLMkip0bGt3JueT1ewN16JXpZJGuzKnhAIh64=
Message-ID: <49159FBE.1030203@gmail.com>
Date: Sat, 08 Nov 2008 15:18:38 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Lior Dotan <liodot@gmail.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, charrer@alacritech.com
Subject: Re: [STAGING] slicoss - use kzalloc
References: <491077E3.4010702@gmail.com> <4910C63F.7040309@gmail.com> <491166F5.7030102@gmail.com> <491168DC.6070508@gmail.com> <49116CD1.7090907@gmail.com>
In-Reply-To: <49116CD1.7090907@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2008 10:52 AM, Lior Dotan wrote:
> Fix sizeof to use the right type

Well, next step might be to investigate which allocs might be GFP_KERNEL instead
of GFP_ATOMIC if you want to play with that ;).
