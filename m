Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbZJGHFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbZJGHFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 03:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbZJGHFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 03:05:47 -0400
Received: from mail-qy0-f202.google.com ([209.85.221.202]:44642 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZJGHFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 03:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a+0P43PEAsOn5KA+7KR6wPD31s0gLG82d9jdVQWluRQLiB4hzwFvHgypJDrwY6Asfz
         ip78X0NyVkAH9YcMlZrjrTwtLHRCp18zg+r8+ykQPC6MDqKvhqU4dfXzu9v7bmCEiYJA
         E0z7HrVX+EUxv6hgkS4cEzHDsyzTdXKe5M0ek=
MIME-Version: 1.0
In-Reply-To: <20091007061754.GA7588@july>
References: <20091007061754.GA7588@july>
Date: Wed, 7 Oct 2009 12:35:09 +0530
Message-ID: <5d5443650910070005t48b894ddoc08788c1b14e76a4@mail.gmail.com>
Subject: Re: [PATCH 2/6] Haptic: Documentation for haptic class
From: Trilok Soni <soni.trilok@gmail.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

On Wed, Oct 7, 2009 at 11:47 AM, Kyungmin Park
<kyungmin.park@samsung.com> wrote:
> Describe the haptic class and how to use
>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/haptic-class.txt |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/haptic-class.txt
>
> diff --git a/Documentation/haptic-class.txt b/Documentation/haptic-class.txt
> new file mode 100644
> index 0000000..6bee82a
> --- /dev/null
> +++ b/Documentation/haptic-class.txt
> @@ -0,0 +1,20 @@
> +
> +Haptic handling under Linux
> +========================
> +
> +In its simplest form, the haptic class just allows control of Haptics from
> +userspace. Haptic appears in /sys/class/haptic/. The maximum level of the
> +haptic is defined in max_level file.
> +
> +To use simple. it provides the oneshot mode. Give millisecond time to this
> +property. It working at given time with pre-defined level.

nit-pick: "To make it simple, it provides the one shot mode. Provide
milliseconds time to
this property, and it will be working for the given time with the
pre-defined level."

Please check if my above statement looks better.

> +Of course, you can adjust the level by setting level property
> +
> +# echo ${millisecond} > /sys/class/haptic/<device>/oneshot
> +
> +# echo ${level} > /sys/class/haptic/<device>/level
> +
> +Also you can enable/disable by setting enable property
> +
> +# echo 1 > /sys/class/haptic/<device>/level    -> Enable
> +# echo 0 > /sys/class/haptic/<device>/level    -> Disable
> --
> 1.5.3.3
>
>



-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
