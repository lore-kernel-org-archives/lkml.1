Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbZFMGwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbZFMGwZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 02:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756131AbZFMGwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 02:52:17 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:37063 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbZFMGwR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 02:52:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CGvMSPbg6Q/tEFJs27prE254DDzVr3J1z2jdIBXMq8IAfS4cBGrXEy7tPJp9Ks+XO0
         0nyQlToGnjPego6z3LH4ua4hEZdvafALUP1760dX/e6YLgwre30NUt4hriLY6zZ7mVme
         yG9Mr2R5LE7p7t0A4BPk7N63qxh36oRYgta2U=
MIME-Version: 1.0
In-Reply-To: <20090612223255.GD14878@aniel.lan>
References: <20090612223255.GD14878@aniel.lan>
Date: Sat, 13 Jun 2009 08:52:17 +0200
Message-ID: <71cd59b00906122352g77e8afdeh235c2a73b323a0d7@mail.gmail.com>
Subject: Re: [PATCH 0/2] eeepc-laptop: add 3G rfkill support for 901Go
From: Corentin Chary <corentin.chary@gmail.com>
To: Janne Grunau <j@jannau.net>
Cc: acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 12:32 AM, Janne Grunau<j@jannau.net> wrote:
> Hi,
>
> The asus_acpi module coming with the Eee PC 901 Go can turn the internal
> 3G modem on and off. I haven't found updated sources for it (only the
> release from november 2007) but I haven't searched thoroughly nor
> requested updated sources from Asus.
> Adding support to eeepc-laptop looking at objdump output was easy enough
> and probably faster than reply from Asus.
>
> There remain only two little issues:
> - the new values are not added to the end of the CM_ASL* enum but before
>  CM_ASL_LID. I don't think it's a problem since it seems to be unused.
> - The eeepc 1000HE reports 3G control support according to
>  http://wiki.debian.org/DebianEeePC/Models but has no 3G modem. I assume
>  this is an error in the bios.

Hi,
First,
Could you fill http://dev.iksaif.net/projects/acpi4asus/wiki/CMSG with
your model CMSG ?

Then, I was working on a patch to refactor rfkill code in
eeepc-laptop. With this patch, adding 3g rfkill
is only 15-20 lines. I'll add it to acpi4asus git tree soon.
>From here:
 - I can rework your patch
- you can re-send it when rfkill refactoring is here.

as you want =).

-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
