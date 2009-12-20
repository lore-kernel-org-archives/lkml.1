Return-Path: <linux-kernel-owner+w=401wt.eu-S1751655AbZLTNua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbZLTNua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 08:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZLTNu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 08:50:29 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:64399 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbZLTNu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 08:50:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=thrb/YqnbL0wbKLGI62GzuDUo5dzCUrB9MVRYVw7NkeVW9xxJ0PvnrttooIpqe3pXH
         CjaDHA034PQrYU8bdGSCwYdMsA8CM0q2Zl7519URVIXS/RQeGEaEgGdMzOlFqV8J9r8L
         ku1po0Qp8gDrtsU9wxu2bFs4NlsNG6Z1ctYxs=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: correct size calculation of bzImgae / fix x86 boot
Date: Sun, 20 Dec 2009 14:50:23 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc1-dirty; KDE/4.3.4; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
       Michael Guntsche <mike@it-loops.com>,
       Oliver Hartkopp <oliver@hartkopp.net>, mjt@tls.msk.ru
References: <20091219233457.GA4288@trillian.comsick.at> <20091220091138.GA1793@trillian.comsick.at> <20091220100344.GA6614@merkur.ravnborg.org>
In-Reply-To: <20091220100344.GA6614@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912201450.23559.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 of December 2009, Sam Ravnborg wrote:
			\
> -printf "%08x" $$dec_size |						\
> +/usr/bin/printf "%08x" $$dec_size |						\
>  	sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'	\
>  )
> 

Here printf is in /bin/ and not in /usr/bin.

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
