Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbXKAR3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbXKAR3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbXKAR3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:29:41 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59081 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbXKAR3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:29:39 -0400
Date: Thu, 1 Nov 2007 18:29:38 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: casey@schaufler-ca.com, akpm@osdl.org, torvalds@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH] Smackv9: Use a stateful parser for parsing Smack rules
In-Reply-To: <20071101155445.GB19231@ubuntu>
Message-ID: <Pine.LNX.4.64.0711011826470.24502@fbirervta.pbzchgretzou.qr>
References: <20071101155445.GB19231@ubuntu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 1 2007 17:54, Ahmed S. Darwish wrote:
>+
>+static inline int isblank(char c)
>+{
>+	return (c == ' ' || c == '\t');
>+}

Use isspace().

>+	for (i = 0; i < count && data[i]; i ++)
>...
>+			subjectstr[(*label_len) ++] = data[i];

i++ w/o space
