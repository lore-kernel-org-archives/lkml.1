Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab0BDFbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 00:31:31 -0500
Received: from mail-yx0-f189.google.com ([209.85.210.189]:35580 "EHLO
	mail-yx0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab0BDFba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 00:31:30 -0500
Message-ID: <4B6A5BAA.2030908@billgatliff.com>
Date: Wed, 03 Feb 2010 23:31:22 -0600
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PWM PATCH 1/5] API to consolidate PWM devices behind a common
 user and kernel interface
References: <cover.1265094517.git.bgat@billgatliff.com> <c5873aa7c5d20254a9e54fc1ff179345b77c16b5.1265094517.git.bgat@billgatliff.com> <BD79186B4FD85F4B8E60E381CAEE190902152ADB@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190902152ADB@mi8nycmail19.Mi8.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten wrote:
>
> Your older patch just used printk's to output the messages.  I think the
> Oops is being caused by the dev_<level>(pwm->dev, ...).  Where is pwm->dev
> being setup?
>   

Good question!  Makes me think that it isn't...

I'm traveling back to my office at the moment, should be back in late
tomorrow or Friday a.m.  I'll look at this then.

The intention was to save the result from device_create() called from
__pwm_create_sysfs(), but I'm suspicious that the patch I posted doesn't
have that code for some reason.  My local git repo here doesn't seem to
have it.  Hmmm...


b.g.

-- 
Bill Gatliff
bgat@billgatliff.com


