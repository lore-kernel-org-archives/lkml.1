Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697Ab0ASRXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab0ASRXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 12:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392Ab0ASRXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 12:23:38 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:58944 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab0ASRXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ecq5qTOVbBcGUDkMZUx+8ur/PWd54iYkGBlmpaXVw1cy8SVSUyhxr0jBaYt7Uo6LNR
         iOP455hv8dyoIsqG390Rw1bNVsoK0hUN7wFRXioHgA4/WyDV3fzMtEDcAG1yrszS9iBh
         jfMNNQEAmTqTU9MfVUuJTUSGwbzBbn8qFmiAU=
MIME-Version: 1.0
In-Reply-To: <20100119142545.GB3473@hack>
References: <1263883920-17289-1-git-send-email-vapier@gentoo.org> 
	<20100119142545.GB3473@hack>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 19 Jan 2010 12:23:16 -0500
Message-ID: <8bd0f97a1001190923p6104acb4if5ec7225d549b713@mail.gmail.com>
Subject: Re: [PATCH] kconfig: dont hardcode path to lsmod
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 09:25, Américo Wang wrote:
> On Tue, Jan 19, 2010 at 01:52:00AM -0500, Mike Frysinger wrote:
>>The lsmod utility has always been installed into /bin with the newer
>>module-init-tools package, so let lsmod be found via PATH instead of
>>hardcoding the old modutils /sbin path.
>>
>
> Some distro doesn't set /sbin to PATH, so for me a better solution
> would be making PATH contain /sbin, and then use "lsmod".

read my changelog -- module-init-tools has always installed into /bin.
 so what your distro does with /sbin doesnt matter.
-mike
