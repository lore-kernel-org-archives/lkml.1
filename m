Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbYFXXfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbYFXXfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 19:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYFXXe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 19:34:59 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:56395 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbYFXXe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 19:34:58 -0400
Date: Tue, 24 Jun 2008 16:32:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Frederik Schwarzer <schwarzerf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] some typo fixes in docs and comments
Message-Id: <20080624163237.f5d97a48.randy.dunlap@oracle.com>
In-Reply-To: <200806241611.17959.schwarzerf@gmail.com>
References: <200806241611.17959.schwarzerf@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 16:11:17 +0200 Frederik Schwarzer wrote:

> Hi,
> 
> while reading the help of a kernel module config, I found a typo.
> Since this is a quite common typo, I looked for it further and
> fixed it where I found it.
> 
> I hope this is the right address for this kind of things.

Hi Frederik,

This probably should be sent to (from the MAINTAINERS file):

TRIVIAL PATCHES
P:	Jesper Juhl
M:	trivial@kernel.org
L:	linux-kernel@vger.kernel.org
S:	Maintained

and you can add:
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.


> ---
>  Documentation/dell_rbu.txt              |    4 ++--
>  Documentation/laptops/thinkpad-acpi.txt |    2 +-
>  Documentation/networking/tuntap.txt     |    2 +-
>  arch/m68k/kernel/traps.c                |    2 +-
>  drivers/acpi/executer/exprep.c          |    2 +-
>  drivers/acpi/executer/exresolv.c        |    2 +-
>  drivers/acpi/executer/exstore.c         |    2 +-
>  drivers/acpi/resources/rscreate.c       |    2 +-
>  drivers/acpi/utilities/utobject.c       |    4 ++--
>  drivers/char/epca.c                     |    2 +-
>  drivers/cpufreq/Kconfig                 |    4 ++--
>  drivers/input/keyboard/atkbd.c          |    2 +-
>  drivers/macintosh/Kconfig               |    2 +-
>  drivers/misc/phantom.c                  |    2 +-
>  fs/ncpfs/ioctl.c                        |    2 +-
>  include/acpi/acmacros.h                 |    2 +-
>  include/acpi/actypes.h                  |    2 +-
>  include/asm-x86/desc_defs.h             |    2 +-
>  include/linux/ncp_fs.h                  |    2 +-
>  mm/slub.c                               |    2 +-
>  sound/oss/aedsp16.c                     |    2 +-
>  21 files changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/Documentation/dell_rbu.txt b/Documentation/dell_rbu.txt
> index 2c0d631..c11b931 100644
> --- a/Documentation/dell_rbu.txt
> +++ b/Documentation/dell_rbu.txt
> @@ -81,8 +81,8 @@ Until this step is completed the driver cannot be unloaded.
>  Also echoing either mono ,packet or init in to image_type will free up the
>  memory allocated by the driver.
> 
> -If an user by accident executes steps 1 and 3 above without executing step 2;
> -it will make the /sys/class/firmware/dell_rbu/ entries to disappear.
> +If a user by accident executes steps 1 and 3 above without executing step 2;

s/;/,/

> +it will make the /sys/class/firmware/dell_rbu/ entries disappear.
>  The entries can be recreated by doing the following
>  echo init > /sys/devices/platform/dell_rbu/image_type
>  NOTE: echoing init in image_type does not change it original value.


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
