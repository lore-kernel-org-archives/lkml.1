Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZGVJ4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZGVJ4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZGVJ4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:56:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:9259 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZGVJ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:56:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JqMGRQxQ66TgW88NPCGRr/SQdhpkB3dQaSl+aZNmfwkp9jIuhEt1cAmnjPWDnjQJ3s
         Zgwo3ZIMV0TXm/7ur/ToA/hN0BXFmPNWwG9y652IW2j+pBt1LJOpcAZlyGuISCMl23R8
         AJFr/lcasGJmRzxy636iwidjnqBDwUiBj3ULM=
Date: Wed, 22 Jul 2009 17:58:18 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH/RFC] Move generated files to include/generated
Message-ID: <20090722095818.GH6281@cr0.nay.redhat.com>
References: <20090721211040.GA7688@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721211040.GA7688@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 11:10:40PM +0200, Sam Ravnborg wrote:
>In 2.6.30 we introduced support for adding generated
>files to a dedicated directory named "include/generated".
>


Personally, I don't like this, I hate to see
#include <generated/foo.h>
.

>This had a number of benefits:
>
>  - avoid mixing generated and normal files

I don't think this is an advantage...


>  - allow us to finally kill the asm symlink


This makes sense, but it looks like only when 'make O=xxx',
no?


>  - simpler .gitignore rules
>  - simpler list of mrproper files

Neither these two.

The benifits we get is little, I think.

Thanks.
