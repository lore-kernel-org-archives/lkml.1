Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbZADMXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbZADMXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 07:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZADMXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 07:23:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:40700 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbZADMXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 07:23:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ZYq8gjbQR6Qkh4sfueC0nH/NkK0ivMzzIyYnmqRjLvOXXXn0xtQwReHDpVpdu8iEhT
         vwAc+2eNt+n6reLQnATykOf6q5khBSm6yYD+Tv3D4m/Ygcn5rWdZZR8ooy9xWoBu83zG
         z+T35DQbkLk71V52HA7qOcfynqQjzI7dxLBEI=
Message-ID: <4960AA25.4070002@gmail.com>
Date: Sun, 04 Jan 2009 13:23:01 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: david@lang.hm, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>, yhlu.kernel@gmail.com
Subject: Re: early exception error
References: <20090102174845.GD5372@localhost> <20090102175226.GE5372@localhost> <alpine.DEB.1.10.0901021131210.21567@asgard.lang.hm> <20090102203058.GH5372@localhost> <alpine.DEB.1.10.0901030823190.23262@asgard.lang.hm> <20090103161052.GB11093@localhost> <alpine.DEB.1.10.0901031118450.23262@asgard.lang.hm> <20090103190316.GB7367@localhost> <20090103212426.GC7367@localhost> <496001A3.1040201@gmail.com> <20090104112919.GC7632@localhost>
In-Reply-To: <20090104112919.GC7632@localhost>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov write:
>  static inline struct mem_section *__nr_to_section(unsigned long nr)
>  {
> +	BUG_ON(SECTION_NR_TO_ROOT(nr) >= NR_SECTION_ROOTS);

sidenote: David, you should get early exception 6.
