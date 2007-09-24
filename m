Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbXIXVxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbXIXVxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbXIXVwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:52:54 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:41249 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbXIXVwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:52:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BMC8j5mZLwg38aCHObKnN06eY6k0Jzh8p2x+X+qzZz/Xl+OpD1MxU4vNmhhMeTm5q5qeZ5e9TpkFKccz1UxSUkIorgkluS1HrhcZDesL+80o+6wVU5+qdZBHSNEvWJxMNTlR9fWUXVEVwKD8PnLJr+IEKJ4A4qaPrjtpIvS/wsg=
Message-ID: <e4c519350709241452l33c2f1b6m8ab943460248656f@mail.gmail.com>
Date: Mon, 24 Sep 2007 23:52:51 +0200
From: "Maurizio Monge" <maurizio.monge@gmail.com>
To: "Catalin Constantin" <catalin@efirst.ro>
Subject: Re: HSM violation with ahci+WDC WD1600BEVS-22RST0
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <138995186.20070924163607@efirst.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <138995186.20070924163607@efirst.ro>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No, i did not manage to improve (it should NOT be a dangerous error BTW).
I simply think that this issue is because of buggy firmware, so i
posted to linux-ide a patch to blacklist this hard disk from using NCQ
(because it is triggering spurious completions).
I don't know what the "blacklisting policy" is for linux kernel
developers, i think that, since there probably are a lot of buggy
drives for NCQ and so, a module parameter to disable NCQ while loading
libata could be useful.
Best regards.

On 9/24/07, Catalin Constantin <catalin@efirst.ro> wrote:
> Hello,
>
> Did you manage to find out why were you getting thoes messages ATA
> related ?
>
> I am having the same issue and some help would be very handy.
>
> Thank you and sorry for disturbing you,
>
> --
> Catalin Constantin
> Efirst - www.efirst.ro
> http://www.cabanova.ro
>
>


-- 
Ciao
Maurizio
http://stregatto.wordpress.com

"Well we all shine on
Like the moon and the stars and the sun" (John Lennon)
