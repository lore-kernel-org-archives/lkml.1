Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbYJAIij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbYJAIij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbYJAIib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:38:31 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:27303 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbYJAIia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:38:30 -0400
Date: Wed, 1 Oct 2008 10:37:34 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric Olsen" <eolsen@google.com>
Subject: Re: [PATCH] new hwmon driver adt7462
Message-ID: <20081001103734.29608fc2@hyperion.delvare>
In-Reply-To: <20081001065413.GG10750@tree.beaverton.ibm.com>
References: <20081001065413.GG10750@tree.beaverton.ibm.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Tue, 30 Sep 2008 23:54:14 -0700, Darrick J. Wong wrote:
> New driver to feed on.  As Jean mentioned a couple of years ago, this
> chip is a beast with odd combinations of 8 fans, 4 temperatures, and
> 13 voltage sensors.  This driver has been tested on an IntelliStation
> Z30.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  Documentation/hwmon/adt7462 |   67 +
>  drivers/hwmon/Kconfig       |   10 
>  drivers/hwmon/Makefile      |    1 
>  drivers/hwmon/adt7462.c     | 1991 +++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 2069 insertions(+), 0 deletions(-)

Two years ago, Eric Olsen (Cc'd) asked for support for this device and
even said he would write the driver himself. We didn't hear from him
since then. Now that we have a driver, maybe Eric can help testing it
and maybe even reviewing it?

I clearly do not have the time for this myself (not on my free time, at
least.)

-- 
Jean Delvare
