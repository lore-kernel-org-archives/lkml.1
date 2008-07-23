Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbYGWNpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbYGWNpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 09:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbYGWNpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 09:45:11 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:21616 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYGWNpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 09:45:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lBoHzJ2L+q1hJs+TzO4XI2SaTaeTn9rwtLSLVyrqGTjqzy7VkCAE+Sr4SUBjf/Hp8/
         lGSaVxmvj/PYItUgzTGi9WbYxInQCyoDxbt09EHEGu+GZjXso+KovbT59fnB+n2TNlGB
         pf8bhAe0jDB1XkcaiSjbahOPP3DdFFeIJZZZk=
Message-ID: <a1d7a2f20807230645t461265ecu2d9e7f70484a8c91@mail.gmail.com>
Date: Wed, 23 Jul 2008 15:45:09 +0200
From: "Jerome Arbez-Gindre" <jeromearbezgindre@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: New IDX in linux/connector.h ?
Cc: linux-kernel@vger.kernel.org, deweerdt@free.fr
In-Reply-To: <20080723125307.GA12017@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a1d7a2f20807230540l4aa7e3f5i1511a2ea71fed8a9@mail.gmail.com>
	 <20080723125307.GA12017@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

>> Would it be possible to declare in linux/connector.h an IDX for the
>> BB, without any restriction on the VAL the BB could use?
>
> Sure.
> VAL (which is 'value' of course) is a private 'offset' inside given
> index (IDX), so when you register single IDX all corresponding VALs
> belong to the same user.

I meant:

 diff --git a/include/linux/connector.h b/include/linux/connector.h
index 96a89d3..361996c 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -38,6 +38,7 @@
 #define CN_W1_VAL			0x1
 #define CN_IDX_V86D			0x4
 #define CN_VAL_V86D_UVESAFB		0x1
+#define CN_IDX_BB			0x5

 #define CN_NETLINK_USERS		5

> I even wanted to have private indexes, i.e. those which are supposed to
> be used by out-of-the-tree code, and no in-kernel users would ever touch
> this numbers.

So which numbers am I suppose to use ... taking account that BB will
probably stay for a long time out-of-the-tree ?

Thanks

              Jerome Arbez-Gindre
