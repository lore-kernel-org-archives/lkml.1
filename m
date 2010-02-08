Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab0BHNgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 08:36:43 -0500
Received: from mail-fx0-f211.google.com ([209.85.220.211]:39994 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab0BHNgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 08:36:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=fH1NJvRBXjDFb/buchUQ5xSrzLh92rpoFPI+jw6hW6VdrM7wKLQgS22Y5N1KPEDTf6
         wMlS5LOlJJjnegOEGz6Tf8YgLc/jr4nqvbq7ELZVWbTgp9o6ck7Z3fTVJaEC42iJD+yW
         dGWZw3sZ/fxpw0vQKkNqXRpLhvG+21BQ+G7aM=
MIME-Version: 1.0
Date: Mon, 8 Feb 2010 11:36:39 -0200
X-Google-Sender-Auth: 94bde605ec002379
Message-ID: <be7a9f3d1002080536v4c38f6e7k492fd09fdab72b5a@mail.gmail.com>
Subject: i810fb: Breaks EDID for Xorg
From: Otavio Salvador <otavio@ossystems.com.br>
To: Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

After some time looking for why one system had EDID working, for Xorg,
and other don't I found the reason being CONFIG_FB_I810.

When I enable CONFIG_FB_I810 the Xorg VBE reading fails; if I disable
it, it works fine.

Anyone has any idea how to fix it?

Cheers,

-- 
Otavio Salvador                  O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854         http://projetos.ossystems.com.br
