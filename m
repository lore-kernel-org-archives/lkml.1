Return-Path: <linux-kernel-owner+w=401wt.eu-S1761293AbXJOPKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761293AbXJOPKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 11:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbXJOPKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 11:10:37 -0400
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:61829 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754527AbXJOPKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 11:10:36 -0400
Date: Mon, 15 Oct 2007 17:10:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH v3] hwmon: Add power meter spec  to
 Documentation/hwmon/sysfs-interface
Message-ID: <20071015171029.39ab3fe6@hyperion.delvare>
In-Reply-To: <20071009203923.GJ16752@tree.beaverton.ibm.com>
References: <20071009203923.GJ16752@tree.beaverton.ibm.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Tue, 9 Oct 2007 13:39:24 -0700, Darrick J. Wong wrote:
> Update the hwmon sysfs interface documentation to include a specification
> for power meters.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  Documentation/hwmon/sysfs-interface |   31 +++++++++++++++++++++++++++++++
>  1 files changed, 31 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
> index db7bb4a..4e0fb20 100644
> --- a/Documentation/hwmon/sysfs-interface
> +++ b/Documentation/hwmon/sysfs-interface
> @@ -324,6 +324,37 @@ curr[1-*]_input	Current input value
>  		Unit: milliampere
>  		RO
>  
> +*********
> +* Power *
> +*********
> +
> +power[1-*]_average		Average power use
> +				Unit: microWatt
> +				RO
> +
> +power[1-*]_average_highest	Historical average maximum power use
> +				Unit: microWatt
> +				RO
> +
> +power[1-*]_average_lowest	Historical average minimum power use
> +				Unit: microWatt
> +				RO
> +
> +power[1-*]_input		Instantaneous power use
> +				Unit: microWatt
> +				RO
> +
> +power[1-*]_input_highest	Historical maximum power use
> +				Unit: microWatt
> +				RO
> +
> +power[1-*]_input_lowest		Historical minimum power use
> +				Unit: microWatt
> +				RO
> +
> +power[1-*]_reset_history	Reset input_highest, input_lowest,
> +				average_highest and average_lowest.
> +				WO
>  
>  **********
>  * Alarms *

Looks good, thanks for your patience :)

Acked-by: Jean Delvare <khali@linux-fr.org>

Note that lm-sensors 3 still lacks support for power meters, if you
want it you'll have to submit a patch.

-- 
Jean Delvare
