Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZKHQ4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZKHQ4d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbZKHQ4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:56:32 -0500
Received: from borg.medozas.de ([188.40.89.202]:43780 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbZKHQ4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:56:32 -0500
Date: Sun, 8 Nov 2009 17:56:37 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>
cc: linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com
Subject: Re: [PATCH v4 10/12] string: factorize skip_spaces and export it to
 be generally available
In-Reply-To: <c7d3b02b5e28eaa54a5360d57dfd177c44320187.1257602781.git.andre.goddard@gmail.com>
Message-ID: <alpine.LSU.2.00.0911081755500.30674@obet.zrqbmnf.qr>
References: <cover.1257602781.git.andre.goddard@gmail.com> <c7d3b02b5e28eaa54a5360d57dfd177c44320187.1257602781.git.andre.goddard@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2009-11-07 17:30, André Goddard Rosa wrote:

>+char *skip_spaces(const char *str)

>@@ -352,10 +366,7 @@ char *strstrip(char *s)
> 		end--;
> 	*(end + 1) = '\0';
> 
>-	while (*s && isspace(*s))
>-		s++;
>-
>-	return s;
>+	return (char *)skip_spaces(s);
> }

sparse would probably say "how much more casting to the same type do you want?"
It is already char*.
