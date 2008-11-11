Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbYKKLeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbYKKLeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 06:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbYKKLd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 06:33:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:50275 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbYKKLdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 06:33:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ay7p2WHHnbgjXgXQTquRujA/uYV4t2dJDyS0Y3w1FeYeHjdhF5zT9rwjJluCmcaTWV
         0+BU5BFoM3We6izmDQPTLJ+wha99poh3jT8+u1esfOxE4rhDDuaJS/JOwATeaS7asMot
         /0nIGpEkZqG/EUNIPJ0FLTCQZWCXdYM5LMM6o=
Message-ID: <49196DA1.3040104@gmail.com>
Date: Tue, 11 Nov 2008 12:33:53 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: "GARCIA DE SORIA LUCENA, JUAN JESUS" <juanj.g_soria@grupobbva.com>
CC: Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Regression: Boot hang sizing transparent PCI-to-PCI bridgesince
 after 2.6.25-r7.
References: <D913A682D10DBA4097B5D068D281B09B0266F65B@S1128EXE.bbva.igrupobbva> <49180973.6080808@gmail.com> <20081110175815.GA7650@us.ibm.com> <D913A682D10DBA4097B5D068D281B09B0266F9B0@S1128EXE.bbva.igrupobbva>
In-Reply-To: <D913A682D10DBA4097B5D068D281B09B0266F9B0@S1128EXE.bbva.igrupobbva>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GARCIA DE SORIA LUCENA, JUAN JESUS napsal(a):
> resource_size_t type
> (defined in linux/types.h) being u64. Perhaps it's u32 in a 32 bit
> architecture.

Unless you have RESOURCES_64BIT=y which is the default on x86_32 now.

