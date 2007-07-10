Return-Path: <linux-kernel-owner+w=401wt.eu-S1764205AbXGJSfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764205AbXGJSfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758236AbXGJSfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:35:34 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:18511 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbXGJSfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:35:33 -0400
Date: Tue, 10 Jul 2007 20:35:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [x86 setup 20/33] Console-writing code for the new x86 setup
 code
In-Reply-To: <11840380363720-git-send-email-hpa@zytor.com>
Message-ID: <Pine.LNX.4.64.0707102033060.11053@fbirervta.pbzchgretzou.qr>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840361432207-git-send-email-hpa@zytor.com> <11840362483663-git-send-email-hpa@zytor.com>
 <11840363531039-git-send-email-hpa@zytor.com> <11840364593068-git-send-email-hpa@zytor.com>
 <1184036564610-git-send-email-hpa@zytor.com> <11840366692770-git-send-email-hpa@zytor.com>
 <11840367741994-git-send-email-hpa@zytor.com> <11840368791603-git-send-email-hpa@zytor.com>
 <11840369841576-git-send-email-hpa@zytor.com> <11840370903975-git-send-email-hpa@zytor.com>
 <11840371953778-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com>
 <11840374052662-git-send-email-hpa@zytor.com> <1184037510289-git-send-email-hpa@zytor.com>
 <11840376162370-git-send-email-hpa@zytor.com> <11840377211519-git-send-email-hpa@zytor.com>
 <11840378261081-git-send-email-hpa@zytor.com> <11840379311574-git-send-email-hpa@zytor.com>
 <11840380363720-git-send-email-hpa@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 9 2007 19:51, H. Peter Anvin wrote:
>+
>+static inline int isdigit(int ch)
>+{
>+	return (ch >= '0') && (ch <= '9');
>+}

I'd say static inline unsigned int isdigit(unsigned char), since ASCII does not
realistically exceed 255.

>+static int strnlen(const char *s, int maxlen)

unsigned int,  and               unsigned int, too?
The glibc strnlen type also uses unsigned types.




	Jan
-- 
