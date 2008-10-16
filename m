Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYJPOji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYJPOji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 10:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbYJPOjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 10:39:00 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:21734
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755516AbYJPOi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:38:59 -0400
X-IronPort-AV: E=Sophos;i="4.33,423,1220220000"; 
   d="scan'208";a="18177860"
Date: Thu, 16 Oct 2008 16:38:56 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Bodo Eggert <7eggert@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use PC-BIOS NUMLOCK flag
Message-ID: <20081016143856.GD5071@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
References: <alpine.LSU.0.999.0810161358540.5404@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LSU.0.999.0810161358540.5404@be1.lrz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Bodo Eggert, le Thu 16 Oct 2008 13:59:49 +0200, a écrit :
> +	  If you have an alternative firmware like OpenFirmware or LinuxBios,
> +	  this flag might not be set correctly, which results in a random state
> +	  of the Numlock key.

That's an issue. That means that distributions will just not enable,
and thus the flag is not really useful, since people who would
compile their own kernel would very likely have already setup their
initialization scripts into calling setleds +num (or just set LEDS=+num
in /etc/console-tools/config on a debian machine).

Samuel
