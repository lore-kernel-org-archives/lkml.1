Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZLZP5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZLZP5p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 10:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZLZP5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 10:57:44 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:50713 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbZLZP5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 10:57:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gJQxmbykSXI6Q4Q226hoWrJVnzwFwOtdIK1lw/bZCah98XcDL92CmPP2E11ND77r/B
         Sn7M0iIK9bEVcv4hPaDWCpBmtBZNE8S/xfzlkl/aqkUsSOAA8yyAy3ynKQUHODuJk6w8
         /9Lq1qxswcHvlh9H81Cmp576favF4Jm/16Veg=
MIME-Version: 1.0
In-Reply-To: <tkrat.92e0244677f2fc0a@s5r6.in-berlin.de>
References: <tkrat.edaaa9d0f51812e8@s5r6.in-berlin.de>
	 <tkrat.92e0244677f2fc0a@s5r6.in-berlin.de>
Date: Sat, 26 Dec 2009 07:57:42 -0800
X-Google-Sender-Auth: 8c7b70fa4104426e
Message-ID: <27dd34e60912260757yf0b1f76w5c914c104a2dfdf6@mail.gmail.com>
Subject: Re: [PATCH 4/5] firewire, ieee1394: update MAINTAINERS entries
From: Dan Dennedy <dan@dennedy.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       Ben Collins <ben.collins@ubuntu.com>,
       Kristian Hoegsberg <krh@bitplanet.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Dec 25, 2009 at 4:36 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Ben and Kristian have not been involved in maintenance of the IEEE 1394
> drivers for quite some time; submitters are not required to Cc them on
> patches.
>
> The linux1394.org domain has been dead for a while and is no longer
> under control of a Linux developer.  The current web site of the
> Linux 1394 project is http://ieee1394.wiki.kernel.org/.
>
> The classic drivers/ieee1394/ stack is now obsolete from the development
> point of view, though still a useful alternative in productive use.  But
> nobody should attempt to submit style cleanup patches for it or to
> develop new drivers on top of this stack, hence mark its MAINTAINERS
> entry as Obsolete.
>
> drivers/ieee1394/raw1394*, like the rest of the old stack, does not
> receive bigger code changes anymore, hence shrink the MAINTAINERS
> database a bit by dropping raw1394's special entry.  If something
> important and urgent is going to come up for raw1394, I will make sure
> that Dan will be notified of it besides via linux1394-devel.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: Ben Collins <ben.collins@ubuntu.com>
> Cc: Dan Dennedy <dan@dennedy.org>
> Cc: Kristian Hoegsberg <krh@bitplanet.net>

Signed-off-by: Dan Dennedy <dan@dennedy.org>

> ---
>  MAINTAINERS |   15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
>
> Index: linux-2.6.33-rc2/MAINTAINERS
> ===================================================================
> --- linux-2.6.33-rc2.orig/MAINTAINERS
> +++ linux-2.6.33-rc2/MAINTAINERS
> @@ -2169,10 +2169,9 @@ F:       drivers/hwmon/f75375s.c
>  F:     include/linux/f75375s.h
>
>  FIREWIRE SUBSYSTEM
> -M:     Kristian Hoegsberg <krh@redhat.com>
>  M:     Stefan Richter <stefanr@s5r6.in-berlin.de>
>  L:     linux1394-devel@lists.sourceforge.net
> -W:     http://www.linux1394.org/
> +W:     http://ieee1394.wiki.kernel.org/
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
>  S:     Maintained
>  F:     drivers/firewire/
> @@ -2705,22 +2704,14 @@ S:      Supported
>  F:     drivers/idle/i7300_idle.c
>
>  IEEE 1394 SUBSYSTEM
> -M:     Ben Collins <ben.collins@ubuntu.com>
>  M:     Stefan Richter <stefanr@s5r6.in-berlin.de>
>  L:     linux1394-devel@lists.sourceforge.net
> -W:     http://www.linux1394.org/
> +W:     http://ieee1394.wiki.kernel.org/
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
> -S:     Maintained
> +S:     Obsolete
>  F:     Documentation/debugging-via-ohci1394.txt
>  F:     drivers/ieee1394/
>
> -IEEE 1394 RAW I/O DRIVER
> -M:     Dan Dennedy <dan@dennedy.org>
> -M:     Stefan Richter <stefanr@s5r6.in-berlin.de>
> -L:     linux1394-devel@lists.sourceforge.net
> -S:     Maintained
> -F:     drivers/ieee1394/raw1394*
> -
>  IEEE 802.15.4 SUBSYSTEM
>  M:     Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>  M:     Sergey Lapin <slapin@ossfans.org>
>
