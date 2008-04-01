Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbYDATGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbYDATGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 15:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbYDATGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 15:06:06 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:25617 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755417AbYDATGD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 15:06:03 -0400
Date: Tue, 1 Apr 2008 20:05:52 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Dave Airlie <airlied@gmail.com>, I2C <i2c@lm-sensors.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Regression (gdm no longer shuts down) - 2.4.24.x and 2.6.25
Message-ID: <20080401190552.GB10046@deepthought>
References: <20080325200714.GA25487@deepthought> <20080326161934.7eae544f@hyperion.delvare> <20080326173701.GA16882@deepthought> <20080326201031.7c2cefb2@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080326201031.7c2cefb2@hyperion.delvare>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 08:10:31PM +0100, Jean Delvare wrote:
> 
> The fact is that there is no i2c-viapro change in 2.6.24.2 nor .4, and
> in fact no i2c change at all. So if anything changed in this driver,
> this has to be a side effect of some (non-i2c) header file change.
> That's a long shot, though.
> 
 I've been attending to more-urgent non-kernel problems.

 In fact, i2c-viapro is not contributory, and drm may have nothing
to do with it - the problem seems to happen with any kernel > 2.6.24,
but not always.

 So, to be clear, 2.6.24.4 with the drm patch reverted, and
2.6.25-rc1, and 2.6.25-rc7 ALL intermittently fail.  I'll start
bisecting.  Actually, I suppose I'd better try 2.6.24 itself a few
more times, so that I have a little more confidence it was 'good'
for this (fortunately, no other users on that box).  Apologies for
attributing possible blame to i2c.

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
