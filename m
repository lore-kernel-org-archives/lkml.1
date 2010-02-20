Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab0BTPHP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 10:07:15 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:60070 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab0BTPHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 10:07:13 -0500
Subject: Re: sysfs lockdep complaint
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20100220150327.GG3000@hack>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com>
	 <1266664814.11514.5.camel@jlt3.sipsolutions.net>
	 <20100220135122.GB3000@hack>
	 <1266674493.18465.9.camel@jlt3.sipsolutions.net>
	 <20100220150327.GG3000@hack>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Feb 2010 16:07:08 +0100
Message-ID: <1266678428.32309.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 23:03 +0800, Américo Wang wrote:
> --- a/drivers/macintosh/windfarm_smu_controls.c
> +++ b/drivers/macintosh/windfarm_smu_controls.c
> @@ -173,6 +173,7 @@ static struct smu_fan_control
> *smu_fan_create(struct device_node *node,
>  
>  	fct->fan_type = pwm_fan;
>  	fct->ctrl.type = pwm_fan ? WF_CONTROL_PWM_FAN : WF_CONTROL_RPM_FAN;
> +	sysfs_attr_init(&fct->ctrl.attr);

hmm.

drivers/macintosh/windfarm_smu_controls.c: In function ‘smu_fan_create’:
drivers/macintosh/windfarm_smu_controls.c:176: error: ‘struct device_attribute’ has no member named ‘key’


johannes

