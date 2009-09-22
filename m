Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZIVPpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZIVPpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbZIVPpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:45:36 -0400
Received: from fifo99.com ([67.223.236.141]:35005 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbZIVPpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:45:35 -0400
Subject: Re: [PATCH 1/4] module: extract __ExPORT_SYMBOL from module.h into
 mod_export.h
From: Daniel Walker <dwalker@fifo99.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, linux-modules@vger.org
In-Reply-To: <1253626718-18887-2-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1253626718-18887-1-git-send-email-alan-jenkins@tuffmail.co.uk>
	 <1253626718-18887-2-git-send-email-alan-jenkins@tuffmail.co.uk>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 08:45:37 -0700
Message-Id: <1253634337.22454.3.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 14:38 +0100, Alan Jenkins wrote:
> +
> +struct kernel_symbol
> +{
> +       unsigned long value;
> +       const char *name;
> +};

One relevant checkpatch error above,

ERROR: open brace '{' following struct go on the same line
#71: FILE: include/linux/mod_export.h:13:
+struct kernel_symbol
+{

You have another similar one in patch 4 ,

ERROR: else should follow close brace '}'
#99: FILE: kernel/module.c:221:
+               }
+               else if (cmp < 0)


Could you correct those?

Daniel

