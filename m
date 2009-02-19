Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbZBSUHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbZBSUHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbZBSUHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:07:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:35058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbZBSUHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:07:05 -0500
Message-ID: <499DBA5B.10908@suse.de>
Date: Thu, 19 Feb 2009 21:00:27 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rlove@rlove.org, protasnb@gmail.com,
       Michael Ruoss <miruoss@student.ethz.ch>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Frank Seidel <frank@f-seidel.de>, multinymous@gmail.com
Subject: Re: [PATCH] hwmon/hdaps: remove redundant sysfs invert
References: <499569A9.5030202@suse.de>	<499807B4.1050606@suse.de>	<4998120C.3030808@suse.de>	<20090215153735.25ee8b05@hyperion.delvare>	<499D543B.6050703@suse.de> <20090219182714.423757a9@hyperion.delvare>
In-Reply-To: <20090219182714.423757a9@hyperion.delvare>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jean Delvare wrote:
> On Thu, 19 Feb 2009 13:44:43 +0100, Frank Seidel wrote:
>> -	hdaps_invert = invert;
>> -	hdaps_calibrate();
> 
> Apparently recalibration is necessary when you change the inversion
> settings. The module parameter, which you made writable in a previous
> patch, does _not_ recalibrate when changed.
> 
> So it was probably not such a good idea to make the module parameter
> writable, and that should be reverted. Which in turn means that the
> sysfs attribute "invert" has to stay.

Fully agree. I'll post a module-writeable revert patch tomorrow.

Thanks,
Frank
