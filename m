Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbYFVTYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbYFVTYo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbYFVTYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:24:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:33527 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876AbYFVTYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:24:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=KVsjr9A+mW3W0udnqC68W2aIRv2hYNUEe8L1Xbjzss39g4O8Ch9GpqUef1OtbbyTNx
         9AsIWDXPUCXcT6sOU4O/VEOGtiNNi2r2jEx/lUtyN9dsIgU1aWvT3Fxn4PTX6CkSkk0D
         ZGuSpqtIkJgYmNx69gO8CJfE2Xylsc13sa7tE=
Message-ID: <84144f020806221224y65e1888fm181f24e89123bacb@mail.gmail.com>
Date: Sun, 22 Jun 2008 22:24:32 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 3/3] relay: Add buffer-only channels; useful for early logging.
Cc: tzanussi@gmail.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, compudj@krystal.dyndns.org,
       vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080621171149.1434e523@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080621171149.1434e523@linux360.ro>
X-Google-Sender-Auth: 9748845d399a1fec
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 5:11 PM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> Allows one to create and use a channel with no associated files. Files
> can be initialized later. This is useful in scenarios such as logging
> in early code, before VFS is up. Therefore, such channels can be
> created and used as soon as kmem_cache_init() completed.
>
> This is needed by kmemtrace to do tracing in early kernel code.
>
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
