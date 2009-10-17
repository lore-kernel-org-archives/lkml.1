Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZJRSZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZJRSZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 14:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbZJRSZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 14:25:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41024 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbZJRSZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 14:25:22 -0400
Date: Sat, 17 Oct 2009 19:01:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Paul Fertser <fercerpav@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org,
       Nelson Castillo <arhuaco@freaks-unidos.net>,
       Balaji Rao <balajirrao@openmoko.org>
Subject: Re: [PATCH] power: pcf50633: introduces battery charging current
	control
Message-ID: <20091017170124.GB1526@ucw.cz>
References: <1255471148-29047-1-git-send-email-fercerpav@gmail.com> <1255471148-29047-2-git-send-email-fercerpav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255471148-29047-2-git-send-email-fercerpav@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Balaji Rao <balajirrao@openmoko.org>

Could we get some changelog here? Like 'it adds new file to sysfs
interface, ...'



> +static ssize_t
> +show_chglim(struct device *dev, struct device_attribute *attr, char *buf)

Could we get meaningful function names?

> @@ -31,6 +31,8 @@ struct pcf50633_platform_data {
>  
>  	int charging_restart_interval;
>  
> +	int chg_ref_current_ma;
> +

...and variable names? This is also inconsistent with name above.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
