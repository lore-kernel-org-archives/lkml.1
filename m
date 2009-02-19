Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbZBSUes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbZBSUes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbZBSUej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:34:39 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:36502 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbZBSUei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:34:38 -0500
Date: Thu, 19 Feb 2009 21:34:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rlove@rlove.org, protasnb@gmail.com,
       Michael Ruoss <miruoss@student.ethz.ch>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Frank Seidel <frank@f-seidel.de>, multinymous@gmail.com
Subject: Re: [PATCH] hwmon/hdaps: remove redundant sysfs invert
Message-ID: <20090219213422.1d36c96c@hyperion.delvare>
In-Reply-To: <499DBA5B.10908@suse.de>
References: <499569A9.5030202@suse.de>
	<499807B4.1050606@suse.de>
	<4998120C.3030808@suse.de>
	<20090215153735.25ee8b05@hyperion.delvare>
	<499D543B.6050703@suse.de>
	<20090219182714.423757a9@hyperion.delvare>
	<499DBA5B.10908@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009 21:00:27 +0100, Frank Seidel wrote:
> Hi,
> 
> Jean Delvare wrote:
> > On Thu, 19 Feb 2009 13:44:43 +0100, Frank Seidel wrote:
> >> -	hdaps_invert = invert;
> >> -	hdaps_calibrate();
> > 
> > Apparently recalibration is necessary when you change the inversion
> > settings. The module parameter, which you made writable in a previous
> > patch, does _not_ recalibrate when changed.
> > 
> > So it was probably not such a good idea to make the module parameter
> > writable, and that should be reverted. Which in turn means that the
> > sysfs attribute "invert" has to stay.
> 
> Fully agree. I'll post a module-writeable revert patch tomorrow.

Don't bother, I've reverted this specific part myself already.

-- 
Jean Delvare
