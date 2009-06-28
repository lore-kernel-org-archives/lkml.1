Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbZF1Jfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbZF1Jfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 05:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZF1Jfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 05:35:36 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:65184 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbZF1Jff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 05:35:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qqVywXssJtZdVKzQn99k5AK+TFqeVp2FyGZyO4GEHOqsBieiPwAcJ1TK2iqNg6FnKc
         QUQzkySOScDo1+xoDPDYx6jF9vYh0JsIIjvwhKaahV1zmNil/OtrVrst1G1mynuLgsB+
         5DcOR7+FhXy6gZcj3xN21fci6VDWneplaKZlg=
MIME-Version: 1.0
In-Reply-To: <4A47246A.5060608@numericable.fr>
References: <4A44EBEE.9070503@numericable.fr>
	 <200906262139.23367.bzolnier@gmail.com>
	 <4A45E095.5070608@numericable.fr>
	 <b6a2187b0906271109q2194cadbv8d20b4bda82bde19@mail.gmail.com>
	 <b6a2187b0906271212u78c00562oaf84ffd740d4aecb@mail.gmail.com>
	 <4A47246A.5060608@numericable.fr>
Date: Sun, 28 Jun 2009 17:35:38 +0800
Message-ID: <b6a2187b0906280235u29302423g789b44229752e0f0@mail.gmail.com>
Subject: Re: [REGRESSION] 2.6.29=>2.6.30 suspend to ram regression (IDE 
	related)
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Etienne Basset <etienne.basset@numericable.fr>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, davem@davemloft.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 4:06 PM, Etienne
Basset<etienne.basset@numericable.fr> wrote:
> same here ; after resume, computer hangs after 2minutes (cannot ping from outside)
> and STR/resume doesn't work if I try from console not from X
> there must be at least one another bug lurking
> If someone hasn't a better idea I'll try another bisection, applying bart's patch at each step

The patch seems to help, but I got a few hangs from STR still.

Jeff.
