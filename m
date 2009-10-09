Return-Path: <linux-kernel-owner+w=401wt.eu-S1760529AbZJIJbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760529AbZJIJbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760454AbZJIJbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:31:08 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:64680 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760343AbZJIJbG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:31:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ti6vUTrLr7IJtif2xfDw+1fZt/++hM9smMQ5EZFl2pUKxVoV34hMLOJhXHjq8jQgmK
         2Dwhypg63X0lWkly6e5N6RDT9F4rhbwLi1lf+QulxCCHUxqtWaxoVlYZnPiirULEKiKf
         y98ON8XWlD9RKblSo53P1HJek9X3uIGrBgY70=
MIME-Version: 1.0
In-Reply-To: <20091009090120.GA24935@july>
References: <20091009090120.GA24935@july>
Date: Fri, 9 Oct 2009 14:59:59 +0530
Message-ID: <5d5443650910090229t6787c762qbcf854c970e117fa@mail.gmail.com>
Subject: Re: [PATCH 2/6] Haptic: Documentation for haptic class (v2)
From: Trilok Soni <soni.trilok@gmail.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

On Fri, Oct 9, 2009 at 2:31 PM, Kyungmin Park <kyungmin.park@samsung.com> wrote:
> Describe the haptic class and how to use
>
> Changelog v1:
>        Apply comments and feedbacks
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
> +The interface is pretty simple - it provides oneshot mode where user
> +can specify duration of the effect (in milliseconds) and desired level
> +Of course, you can adjust the level by setting level property
> +
> +# echo ${millisecond} > /sys/class/haptic/<device>/oneshot
> +
> +# echo ${level} > /sys/class/haptic/<device>/level
> +
> +You can also enable or disable haptics devices by manipulating 'enable' attribute:
> +
> +# echo 1 > /sys/class/haptic/<device>/enable   -> Enable
> +# echo 0 > /sys/class/haptic/<device>/enable   -> Disable
> --
> 1.5.3.3
>
>

Reviewed-by: Trilok Soni <soni.trilok@gmail.com>

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
