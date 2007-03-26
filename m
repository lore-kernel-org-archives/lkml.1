Return-Path: <linux-kernel-owner+w=401wt.eu-S965217AbXCZLCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965217AbXCZLCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965211AbXCZLCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:02:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:38783 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965217AbXCZLCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:02:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GGmlYGNokeo5zk1qcTt1ZvMHSlJpWjoYCgiwQBNATXOIxiwi3ZAjNGRVHd+PwqHTSYnUVkIK5uclS9T/t9LP9k2EA2KSuHnfEaPzPrHXP0qs8IEhTvQ80gR7ydWYX/nbZeV7ckMG8Gtqgu+4aCrw6sAkQ7Fgqf2YZUkRvsQtZEw=
Message-ID: <4607A820.60103@gmail.com>
Date: Mon, 26 Mar 2007 20:01:52 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Wrong IDE cable detection in libata [Re: 2.6.21-rc4-mm1]
References: <20070319205623.299d0378.akpm@linux-foundation.org> <20070326022420.224cc4f2@werewolf-wl>
In-Reply-To: <20070326022420.224cc4f2@werewolf-wl>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:
> Libata seems to misdetect my cable.
> I have double-checked and the cable is 80 pin...

Does the following patch fix your problem?

  http://article.gmane.org/gmane.linux.ide/17444

(You can get the raw message by appending /raw to the URL).

-- 
tejun
