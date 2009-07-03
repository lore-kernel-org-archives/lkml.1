Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbZGCSSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbZGCSSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbZGCSSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:18:17 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:47327 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbZGCSSQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:18:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=C/GLGoqJT9tZ1sn+O0iL8yzuZmSLLiHtK7T72lCuh+DuiKnLmubJtsPVRRfpPztDrI
         OIfRth+Jbk+2oj5OTd7AzfslxOe+GsXUSQLH86oaWIo0rnyxpi65ZhD/ePnYlDA2dz8Q
         vyTyf3qlEBkJN4EtpGivo9aXnnbAbGg+NdMIM=
MIME-Version: 1.0
In-Reply-To: <1246410255-6839-7-git-send-email-adi@vmware.com>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
	 <1246410255-6839-7-git-send-email-adi@vmware.com>
Date: Fri, 3 Jul 2009 20:18:18 +0200
X-Google-Sender-Auth: 73396079e1572e0f
Message-ID: <ea8d860a0907031118o7ad0ad4nbe147b32bba57a29@mail.gmail.com>
Subject: Re: [tpmdd-devel] [PATCH 6/6] tpm_tis: add workarounds for iTPM
From: Marcin Obara <marcin_obara@users.sourceforge.net>
To: Andy Isaacson <adi@vmware.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
       seiji.munetoh@gmail.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/1 Andy Isaacson <adi@vmware.com>:
> Some Lenovo platforms (X200 and T400, maybe others) have an "iTPM" which
> does not quite conform to the TPM spec.  With one small hack the iTPM
> seems to work OK.

Small comment:

Intel iTPM on mobile platforms require this patch.
Intel iTPM on desktop platforms works well without this patch.

--
Marcin
