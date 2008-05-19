Return-Path: <linux-kernel-owner+w=401wt.eu-S1760999AbYESPv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760999AbYESPv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbYESPvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:51:20 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:58144 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbYESPvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Bw1NQ1zfDFt3L1USd0BNBOXbCL/uGtz29zzb1hw8KVgo2ANOvmAuxMlBe2fG5ofsKIRbT7VN7eT+s46ZDYZDBguCB5adIXJ611Vq/lEzUcOnY9z9jfPGaMwRX1+vm4wYBYkYLYk1IZeMILwXMTCjJHvsCYVhCzgbOXZaJyYV/jI=
Date: Mon, 19 May 2008 11:50:47 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bruno Pr?mont <bonbons@linux-vserver.org>
Cc: Linux Input <linux-input@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Subject: Re: Input+S3: extra keycodes forgotten after suspend
Message-ID: <20080519114827.ZZRA012@mailhub.coreip.homeip.net>
References: <200805162225.44284.bonbons@linux-vserver.org> <20080516163318.ZZRA012@mailhub.coreip.homeip.net> <200805162300.06027.bonbons@linux-vserver.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805162300.06027.bonbons@linux-vserver.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruno,

On Fri, May 16, 2008 at 11:00:04PM +0200, Bruno Pr?mont wrote:
> [  252.668456] PM: Finishing wakeup.
> [  252.668456] Restarting tasks ... done.
> [  252.745418] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input7

Ok, so for some reason it could not resume and here it re-detected the
keyboard creating the new input device thus resetting the keymap. The
question is why it had to re-detect. Could you please do

	echo 1 > /sys/modules/i8042/parameters/debug

before suspending and send me full dmesg please?

-- 
Dmitry
