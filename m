Return-Path: <linux-kernel-owner+w=401wt.eu-S933133AbXCTMee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133AbXCTMee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 08:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933315AbXCTMed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 08:34:33 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:3938 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933312AbXCTMeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 08:34:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fQ0vMRrad2ZHfDUqTme6NWUmeOnsEIc+gHki1EU/in6LOkyJ4aQI4CBIKQDfnMVGkmuW48vm7vkXMOe76SRcmzN7sGwC59pTjDRl+gAlhk7NmTAOLb2djYzqFHwq5Cwa2SFihG09dAUics4BKXlGzfTQz/M8AwCBcHVfj6SjRbk=
Message-ID: <b6fcc0a0703200534w179a664dk6bfc6108879bde94@mail.gmail.com>
Date: Tue, 20 Mar 2007 14:34:29 +0200
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Keiichi KII" <k-keiichi@bx.jp.nec.com>
Subject: Re: [RFC][PATCH -mm take3 2/6][resend] support multiple logging
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <45FFD2E5.9070208@bx.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45FFCF31.3040000@bx.jp.nec.com> <45FFD2E5.9070208@bx.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/20/07, Keiichi KII <k-keiichi@bx.jp.nec.com> wrote:
> This patch contains the following changes for supporting multiple logging
>  agents.

> +#define CONFIG_SEPARATOR ";"

CONFIG_* is reserved for configuration options. Since you use
it in only one place just use semicolon directly.
