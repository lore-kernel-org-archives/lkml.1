Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbZKCTGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbZKCTGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbZKCTGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:06:45 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:37161 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZKCTGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:06:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DXmjBbFvW0982b/CJiTx0yRwPwW2gxomW5Lusu+3kwWdqqjDZxJxvd934YRj0PQARI
         JJ72xl3MbVkd0SJ07AxWO5140AL18r0q/jTOnmNuuroDZplRfrSWTa1e7IdC0HH9wFKu
         nVIh8/9M0LLEaY+OooZ5DDaaZJ1uaIGvMhfH8=
MIME-Version: 1.0
In-Reply-To: <20091103190420.GY10555@parisc-linux.org>
References: <1257273488.9427.27.camel@mulgrave.site>
	 <20091103105921.160d5599.akpm@linux-foundation.org>
	 <20091103190420.GY10555@parisc-linux.org>
Date: Wed, 4 Nov 2009 04:06:49 +0900
X-Google-Sender-Auth: cdc475c28af4d2bd
Message-ID: <2f11576a0911031106r555f5515mc2bb2b1c0304cf87@mail.gmail.com>
Subject: Re: [PATCH] strstrip incorrectly marked __must_check
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/4 Matthew Wilcox <matthew@wil.cx>:
>
>  static inline void strsrip_tail(char *str)
>  {
> -       char *x __used;
> -       x = strstrip(str);
> +       char *x = strstrip(str);
> +       BUG_ON(x != str);
>  }

Looks reasonable to me :)
