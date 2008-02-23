Return-Path: <linux-kernel-owner+w=401wt.eu-S1759671AbYBWB5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759671AbYBWB5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 20:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbYBWB45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 20:56:57 -0500
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:58666 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbYBWB44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 20:56:56 -0500
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2008 20:56:56 EST
From: Junio C Hamano <gitster@pobox.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Chase Venters <chase.venters@clientec.com>,
       linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: Re: Question about your git habits
References: <200802221837.37680.chase.venters@clientec.com>
 <Pine.LNX.4.64.0802230221140.21077@fbirervta.pbzchgretzou.qr>
 <20080223014445.GK27894@ZenIV.linux.org.uk>
Date: Fri, 22 Feb 2008 17:51:04 -0800
In-Reply-To: <20080223014445.GK27894@ZenIV.linux.org.uk> (Al Viro's message
 of "Sat, 23 Feb 2008 01:44:45 +0000")
Message-ID: <7vfxvk4f07.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Sat, Feb 23, 2008 at 02:37:00AM +0100, Jan Engelhardt wrote:
>
>> >do you tend to clone the entire repository repeatedly into a series
>> >of separate working directories
>> 
>> Too time consuming on consumer drives with projects the size of Linux.
>
> git clone -l -s
>
> is not particulary slow...

How big is a checkout of a single revision of kernel these days,
compared to a well-packed history since v2.6.12-rc2?

The cost of writing out the work tree files isn't ignorable and
probably more than writing out the repository data (which -s
saves for you).


