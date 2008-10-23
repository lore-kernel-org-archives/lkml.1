Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbYJWRZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbYJWRZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 13:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYJWRZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 13:25:09 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:42919 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbYJWRZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:25:07 -0400
Date: Thu, 23 Oct 2008 13:25:07 -0400
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, ben-linux@fluff.org
Subject: Re: scx200_i2c driver fails to detect any i2c devices in 2.6.26
Message-ID: <20081023172507.GB5682@csclub.uwaterloo.ca>
References: <20081023165419.GA5682@csclub.uwaterloo.ca> <20081023192056.49656653@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023192056.49656653@hyperion.delvare>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 07:20:56PM +0200, Jean Delvare wrote:
> Correct. Not sure how we missed this for years.

scx200s are old, and the people using them in boxes don't upgrade
kernels very often.  I am only now moving from 2.6.18 to 2.6.26 after
all, and noticed it now.

> I2C_CLASS_HWMON | I2C_CLASS_SPD please. I2C_CLASS_ALL is almost never
> what people want, and actually I'm thinking of removing it to prevent
> developers from getting it wrong.

Should I generate a patch against the latest git tree and submit it, or
will one of you add it to your i2c tree yourself?

-- 
Len Sorensen
