Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZBOOiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZBOOiB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 09:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZBOOhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 09:37:50 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:20198 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbZBOOhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 09:37:48 -0500
Date: Sun, 15 Feb 2009 15:37:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rlove@rlove.org, protasnb@gmail.com,
       Michael Ruoss <miruoss@student.ethz.ch>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Frank Seidel <frank@f-seidel.de>, multinymous@gmail.com
Subject: Re: [PATCHv3] hwmon/hdaps: Fix bug 7154 inversion of separate axis
Message-ID: <20090215153735.25ee8b05@hyperion.delvare>
In-Reply-To: <4998120C.3030808@suse.de>
References: <499569A9.5030202@suse.de>
	<499807B4.1050606@suse.de>
	<4998120C.3030808@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

On Sun, 15 Feb 2009 14:01:00 +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> Fix for kernel.org bug #7154:hdaps inversion of
> each axis. This version is based on the work
> from Michael Ruoss <miruoss@student.ethz.ch>.
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  drivers/hwmon/hdaps.c |   64 +++++++++++++++++++++++++-------------------------
>  1 file changed, 33 insertions(+), 31 deletions(-)

Patch applied, thanks. Suggestions for incremental patches:

* Actually fix bug #7154 (apparently Thinkpad X41 needs to invert Y
  axis)
* Get rid of sysfs attribute "invert" (redundant with eponymous module
  parameter)

-- 
Jean Delvare
