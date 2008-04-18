Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbYDRRQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbYDRRQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 13:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757577AbYDRRQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 13:16:08 -0400
Received: from rv-out-0708.google.com ([209.85.198.250]:45772 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757016AbYDRRQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 13:16:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kHQz4S2X3zyoyn9qA7X7U0WQRNu0nH1T9UAVAoHdM3zOYXUWoIiISSp9BWxhoKQ1kC4qXLq3I9SlMgmO5hH8+Ai1AUDT0S9tj0k1PitF/lPK2s76+iEd4G5BY/vqWSHaZjpCsb4MP7bzoou8RKJNdjbbELBl68Ok2UADZo/ZkMg=
Date: Fri, 18 Apr 2008 13:15:58 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: khali@linux-fr.org, andre@bitwigglers.org, linux-input@vger.kernel.org,
       i2c@lm-sensors.org, linux-kernel@vger.kernel.org, vapier.adi@gmail.com,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH 1/1] Input/Joystick Driver: add support AD7142 joystick
	driver (v2)
Message-ID: <20080418131149.ZZRA012@mailhub.coreip.homeip.net>
References: <1206643110-8789-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206643110-8789-1-git-send-email-cooloney@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Thu, Mar 27, 2008 at 11:38:30AM -0700, Bryan Wu wrote:
> +	input->keybit[BIT_WORD(BTN_BASE)] = BIT_MASK(BTN_BASE) |
> +						BIT_MASK(BTN_BASE2) |
> +						BIT_MASK(BTN_BASE3) |
> +						BIT_MASK(BTN_BASE4);
> +	input->keybit[BIT_WORD(KEY_UP)] |=  BIT_MASK(KEY_UP) |
> +						BIT_MASK(KEY_DOWN) |
> +						BIT_MASK(KEY_LEFT) |
> +						BIT_MASK(KEY_RIGHT);
> +

Why don't you use REL_X/REL_Y to report directional movement? Using
buttons for that is pretty unusual.

-- 
Dmitry
