Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbYDZNdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbYDZNdv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 09:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYDZNdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 09:33:44 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:15477 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbYDZNdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 09:33:43 -0400
Date: Sat, 26 Apr 2008 15:33:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] adt7473: Minor documentation update
Message-ID: <20080426153330.273df78f@hyperion.delvare>
In-Reply-To: <20080328210604.GA7183@tree.beaverton.ibm.com>
References: <20080328210604.GA7183@tree.beaverton.ibm.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

Sorry for the late review.

On Fri, 28 Mar 2008 14:06:04 -0700, Darrick J. Wong wrote:
> Add a sentence about when fan speed increases to maximum.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  Documentation/hwmon/adt7473 |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/hwmon/adt7473 b/Documentation/hwmon/adt7473
> index 22d8b19..2126de3 100644
> --- a/Documentation/hwmon/adt7473
> +++ b/Documentation/hwmon/adt7473
> @@ -69,7 +69,8 @@ point2: Set the pwm speed at a higher temperature bound.
>  
>  The ADT7473 will scale the pwm between the lower and higher pwm speed when
>  the temperature is between the two temperature boundaries.  PWM values range
> -from 0 (off) to 255 (full speed).
> +from 0 (off) to 255 (full speed).  Fan speed will be set to maximum when the
> +temperature sensor associated with the PWM control exceeds temp#_max.
>  
>  Notes
>  -----
> 

Obviously correct.

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
